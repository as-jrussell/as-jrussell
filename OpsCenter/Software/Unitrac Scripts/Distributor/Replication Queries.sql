use unitrac_distribution

exec show_repl_commands declare @hours INT = NULL, @command_count INT = 1000




/*
This proc lists the commands that are currently in the distribution queue, including historical
You can optionally specify how many hours to go back to view (usually it’s only 2-4 hours that are kept), 
and how many commands there should be in a transaction to show it (the default is 1000 – lower than that and you’ll possibly get way too much output).*/


/*
Used in conjunction with show_repl_commands

Pass one of the Xact_seqno values (as a string) displayed by show_repl_commands to show the actual commands within the repl transaction 

The default is to show only the first command in the transaction (usually enough to determine the source of the transaction)

Specify a value of ‘Y’ to @show_all to display all commands in the transaction (just be prepared for it to take a while if it’s a large transaction) */

 

show_repl_latency

/*
Displays the current replication latency stats and times so it can be determined whether it’s logreader (DistCommit) or subscriber (SubCommit) latency that is the main culprit.*/

 
show_repl_status  declare @num_rows INT = 200

/*
Shows the current replication status, first showing the subscriber status messages, and then the logreader status messages

Useful to show if subscriber is processing commands and at what rate, or if there are issues with the log reader and the delivery rate
*/
 

