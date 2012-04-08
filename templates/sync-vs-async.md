# Synchronous vs. Asynchronous

The asynchronous programming model provides only one real advantage over the synchronous programming model. If you have a very large number of clients connecting to the server and the server is not required to respond as quickly as possible, then asynchronous is the way to go.  A good example of a use case for asynchronous programming is serving large media files (e.g. movies) that stream over a long period of time.  Otherwise, the synchronous programming model is the way to go.

## Processes

In the Unix environment a process is an individual memory protected address space running some program. The programs are protected from one another by a feature of the CPU known as the MMU.  This protection prevents one program from having a "wild store" bug that affects the memory of some other program.

While we can think of a process as a standalone program running in its own protected address space, a program can "fork" copies of itself that run as if they are separate programs, with all those copies under control of the main or parent process.  The Unix (OSX) man page for fork says:

```
     Fork() causes creation of a new process.  The new process (child process) is an exact copy of the
     calling process (parent process) except for the following:

           o   The child process has a unique process ID.

           o   The child process has a different parent process ID (i.e., the process ID of the parent
               process).

           o   The child process has its own copy of the parent's descriptors.  These descriptors refer-
               ence the same underlying objects, so that, for instance, file pointers in file objects are
               shared between the child and the parent, so that an lseek(2) on a descriptor in the child
               process can affect a subsequent read or write by the parent.  This descriptor copying is
               also used by the shell to establish standard input and output for newly created processes
               as well as to set up pipes.

           o   The child processes resource utilizations are set to 0; see setrlimit(2).
```

That fork() creates an exact copy of the calling process has an interesting side effect for SilkJS programs. Not only is the main program copied, but the entire state of the V8 JavaScript engine is copied, in the exact state it was at the time of the call to fork().  This means a JavaScript program can call fork() and when fork() returns, the JavaScript in the parent and child processes continues executing from the point in the program immediately calling fork().  That is, when fork() returns, there are now two processes running your JavaScript program in exactly the same state, continuing execution at the same line of code - the line following the call to fork().

Fork() returns a PID, or process ID, of the child process to the parent process.  It returns zero to the child process.  Consider the following snippet of code:

```
var pid = fork();
if (!pid) {
    // this code is running in the child
    // pid is zero, the child can call process.getpid() to get its own PID.
}
else {
    // this code is running in the parent
    // pid is the PID of the child process
}
```

You need to be careful about checking the return of fork() for zero and running the code you want for just the child (e.g. with the if clause above).  You almost certainly do not want to run the same code after fork() in both the child and parent processes!  If the child returns or calls process.exit(), it will terminate, just as any distinct program does.

The operating system's function is to schedule CPU time among all the cores for all the processes that need to execute code.  A hardware timer interrupts the system and the OS kernel may put one process to sleep and wake up another.  This allows two running programs to appear to run at the same time on a system with a single core.  For systems with multiple cores (say, 4 cores), the OS kernel would allow 4 processes to run simultaneously (one per core).

## Blocking

A process may exist but may not need to run much of the time.  In fact, event driven programming is ideal for user interfaces.  What this means is that while the user isn't directly interacting with a program's UI (clicking on buttons, menus, scrolling, etc.), the program does not necessarily need to run or use any CPU time at all.  When the program is idle and not needing to use any CPU time, it is said to be blocking.

When a process is in blocking state, the OS kernel will not put some other process to sleep to wake it up; there's no need, after all.  The vast majority of a computer's time is spent with most, or even all, of its processes are in blocking state.

When a program is in blocking state, it is waiting for some sort of event in the operating system to cause it to go into the run state.  Your IDE sits in blocking state until you choose "open a file" from the UI, then it runs to load the file into an IDE window, syntax highlights the code, etc., then it goes back into blocking state.  A key stroke will wake up the IDE process so it can insert the character you type and syntax highlight the code again, then the program goes into blocking state again.

There is nothing wrong with blocking.  Unlike claims you have seen to the contrary, blocking is actually the most natural and common thing that goes on even in asynchronous programs.  What does an asynchronous program do when there are no events going on?  It blocks!

## Blocking I/O, Async I/O

Any sort of I/O can be done as Blocking style or Async style.  Let's consider hard disk I/O, particularly reading in the entire contents of a file.

A disk drive consists of at least one "platter," and at least one "head."  The platter contains magnetic media that is formatted at its lowest level as concentric rings of bytes; these rings are called "tracks." The platter spins below the head, which can read or write bytes to one of those tracks of data at a time.

The operating system uses a "file system" strategy for organizing (typically 512-byte) blocks of data in the tracks into directories and files.

Typically, the file system contains some index of directories and files, which are blocks that identify what files exist, as well as other metadata about the files.  The directory may be stored in one of those concentric rings near the center of the platter, while the actual blocks of data that make up the file may be stored near the edge of the platter.  Or even worse, when the drive is "fragmented," the blocks that make up a file may be scattered across many of the concentric rings.

So as the OS decides it needs to position the head of the drive at one track, the hardware takes a long time, as far as the CPU is concerned, to physically move the head.  During this "seek time," a process ideally blocks so some other process that needs to run can use the CPU instead.  If the file is scattered across many tracks, there is a lot of physical movement of the head required to read in the entire contents of a file.  A program calls the OS' read() method to read from the disk.

With blocking I/O, you call read(), asking the OS to read all of the file's bytes and return when that is complete.  Inside the Kernel, the OS will put the process in blocked state and automatically handle the stepping of the heads, the waiting for the data to be transferred from the disk, etc., to read the entire file.  Since all this is done within the Kernel's address space and control, it is generally done as fast as possible.

With async I/O, you call read(), asking the OS to read all of the file's bytes.  The read() function almost never returns that it read all the file's bytes, just some subset.  If the file is 3x 512 byte sectors stored on three different tracks, the first read may return 512 bytes, even though you asked it to read 1536 bytes.  So you have to call read() again, the second time asking it to read the remaining 1024 bytes.  Again, read() may return just the next 512 bytes.  As you can see, you have to implement logic to repeatedly call read() until the entire file is read in.  To make things worse, if it took 3 read() calls to read in the 1536 bytes, your program performed 3 rather expensive context switches into the OS/Kernel.

If you implemented a tight loop to call read() until all the data is read, your program burns CPU cycles that some other process could have used.  This is not typically what a good programmer would do.  Instead, he'd call the OS select() method to block the process until the next read() call would actually return more than zero bytes.  So async programs actually should block anyway!

There's absolutely nothing wrong with async I/O programming.  It has distinct advantages of being able to support reading from two or more files at the same time.  You call select() to block until  any one of those files' contents are ready to be read().

## Network sockets, bind(), listen(), and accept()

Linux, OSX, FreeBSD, and Windows all implement the Berkeley Sockets (or BSD Sockets) API for network programming.  You program to this API to implement client or server programs.  A server program creates a socket, binds it to a knwon port (e.g. 80 for HTTP), listens on the socket, and then accepts connections on that socket when a client connects.  The connection accepted is a brand new socket that is a pipe between client and server.  There is still a socket bound and listening on the known port; the server can call accept again to get another brand new socket.

A client program creates a socket and connects to a server by IP and port number.  Once a socket is connected between client and server, either side may read or write any sort of binary or textual data that both sides agree upon.  In the case of HTTP, the client generally issues requests as textual data to the server, and the server responds with textual data (e.g. HTML).  In mid stream, the request or response content may change from text (e.g. the headers of a request) to binary (e.g. binary post data, as in a file upload).

The fact that the child process has its own copy of the parent's descriptors makes the pre-fork strategy used by SilkJS HTTP server (as well as Apache and other servers) possible.

## Pre-fork

At its most basic level, SilkJS HTTP server consists of the main program (process) and some number of child processes.  The main program sets up the bound socket, then (pre) forks some fixed number of child processes.  The child processes have their own copy of the bound socket and they block when they call accept.  When a connection from a client program comes in, only one of the child processes is awakened from accept() with a new socket.

The child processes handle the HTTP protocol exchange between the client and server.  If the connection is keep-alive, the child will handle as many requests the client sends in keep-alive mode.  If the connection is close (not keep-alive), the child handles one request, then closes the socket and goes back to blocking in accept() for a new connection.

The programs run by the child process are synchronous, or blocking.  When a child calls read(), it will block in the Kernel until the read has completed, and some other process can use the CPU.  If there are 20 child processes, the server can handle 20 simultaneous keep-alive connections.

This limit is the only real negative to the synchronous model.  However, a really busy server can pre-fork hundreds of child processes to handle hundreds of simultaneous connections.  You are in full control over the number of child processes pre-forked.

The advantage of the synchronous model is that your requests can do whatever top-to-bottom/left-to-right business logic you like (no events, nested callbacks, etc.), and the OS scheduler will assure those requests execute as fast as possible.

So what happens if each request does some intensive sort of computation?  Let's consider a server that is generating <a href="http://en.wikipedia.org/wiki/Julia_set">Julia Sets</a> each request.  If you have a quad core server, SilkJS HTTP will run 4 Julia Set calculations at full speed.  Each child will be busy using near 100% of the CPU doing the calculations.

NOTE: SilkJS HTTP will still have free children waiting for new connections in accept(), so new connections happen as expected.

If there are 8 simultaneous requests for Julia Set calculations, there will be 8 HTTP child processes in run state (not blocking), and the OS scheduler will give each 1/2 of one core over time.  Each of the 8 calculations will finish in about 2x the time, which is exactly what should happen.  If one calculation takes 1 core and 1 second, then 8 calculations should take 4 cores and 2 seconds.

## Async

An async server model is inherently limited to using just one of the CPU cores.  This is not necessarily a bad thing, if you have other processes (e.g. MySQL, sendmail, etc.) running on the same machine that also need to use CPU time.  Note that a hybrid of pre-fork and async is possible - each child pre-forked is written in async manner.

Let's consider some JavaScript/pseudo code implemntation of the heart of an async program:

```
while (true) {
  var ready_fds = select(); // block waiting for a socket or file to be ready to read or write
  ready_fds.each(function(fd) {
    process_io(fd); // BOTTLENECK
  });
}
```

The process_io() function is some sort of state machine implementation.  If a file is being read from disk, the state machine needs to know that 512 bytes have been read, the pending read is for 1024 bytes, etc.

The process_io() method is marked with a comment as a bottleneck for good reason.  The program is only doing one thing at a time, and only runs in one core - there's no fork() involved, etc.  So if process_io() ends up doing 1 second's worth of Julia Set calculation, the next fd in ready_fds won't be processed for a VERY long time.

Granted there are ways around this.  Obviously, process_io() state machine logic should be as tiny and run as fast as possible.  To perform Julia Set calculations, process_io() can spawn a thread or fork a process to do the 1 second calculation and signal (emit an event) through an fd (interprocess communication) so some later process_io() call can deal with the final data.  Or the Juila Set calculations can be performed as a state machine so only a tiny bit of calculation is done per process_io() call, requiring many calls to process_io() before the calculation is complete.

## Performance

SilkJS benchmarks quite well against the competition.  The Apache Benchmark (ab) program consistently shows for myself and others, on a wide variety of hardware and virtualization platforms, that SilkJS' WWW server is seriously fast.

When considering performance and benchmarks, there are two sorts of applications to consider.  First, how fast is the server at serving static content?  After all, WWW content tends to be a lot of static HTML, images, css files, JavaScript files, and so on.  And second, how fast is the server at executing server-side business logic?  After all, RIA applications tend to do a lot of Ajax requests for bits of content to dynamically change part of a page.

SilkJS consistently beats NodeJS at serving both static and dynamic content.  This is to be expected, because SilkJS naturally will use all the CPU cores the hardware has, while NodeJS uses just one.  SilkJS is more than 4x faster than NodeJS on a quad core machine, which indicates a Node of Nodes or cluster configuration won't be faster than SilkJS.

SilkJS blows the doors off of Apache and PHP running server-side business logic.  We're talking orders of magnitude faster.

Here's an example AB benchmark of SilkJS with 20,000 concurrent requests on a core i7 920 laptop:

```
$ ab -t 30 -c 20000 -k http://localhost:9090/sprite.png
This is ApacheBench, Version 2.3 <$Revision: 655654 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        SILK
Server Hostname:        localhost
Server Port:            9090

Document Path:          /sprite.png
Document Length:        13263 bytes

Concurrency Level:      20000
<span style="color: red">Time taken for tests:   2.213 seconds</span>
Complete requests:      50000
Failed requests:        0
Write errors:           0
Keep-Alive requests:    50000
Total transferred:      672450000 bytes
HTML transferred:       663150000 bytes
<span style="color: red">Requests per second:    22598.83 [#/sec] (mean)</span>
Time per request:       885.002 [ms] (mean)
<span style="color: red">Time per request:       0.044 [ms] (mean, across all concurrent requests)</span>
Transfer rate:          296808.26 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    2  22.0      0     315
Processing:     0   22  59.4     12    1117
Waiting:        0   21  59.5     11    1117
Total:          0   24  74.9     12    1432

Percentage of the requests served within a certain time (ms)
  50%     12
  66%     13
  75%     16
  80%     19
  90%     32
  95%     71
  98%    204
  99%    283
 100%   1432 (longest request)
$
```

