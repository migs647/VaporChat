# VaporChat
Example on how to use Vapor with Sockets and REST for a chat server. To use, simply open both projects and start the server first. Feel free to open two different simulators for the client to chat back and forth between them.

# Architecture Overview
Using sockets and REST creates testability and still a good way to signal a change.
![Image of High Level](http://www.servalsoft.com/temp/VaporChatImages/HighLevel.png)

The client and server both have socket managers to keep track of their respected sockets that have been connected. The ChatManager and ChatMediator help process REST connections.
![Image of Client Server relationships](http://www.servalsoft.com/temp/VaporChatImages/ClientServer.png)

Keep in mind this is a Socket / REST hybrid. These OISD connections help explain communication.
![Image of OISD](http://www.servalsoft.com/temp/VaporChatImages/OISD.png)
