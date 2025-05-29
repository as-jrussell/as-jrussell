USE unitrac

---Inbound Message
exec unitrachdstorage..UT_InboundMessage


--Outbound Message
exec unitrachdstorage..UT_OutboundMessage



---Break Down on Message Processing
exec Unitrac..UT_MessageTypeBreakDown

--Counts 
exec Unitrac..UT_Errors_Counts


---Error 
exec Unitrac..UT_Errors


