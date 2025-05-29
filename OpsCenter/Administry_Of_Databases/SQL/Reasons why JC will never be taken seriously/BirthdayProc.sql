use [ThePlayPen]

go

IF OBJECT_ID('dbo.SelectTop1BirthdayParty') IS NOT NULL
    DROP PROCEDURE dbo.SelectTop1BirthdayParty;
GO


CREATE PROCEDURE SelectTop1BirthdayParty 
AS
BEGIN
    -- Print the birthday message
    PRINT 'Happy 1st Birthday! You are our SELECT TOP 1!'

    -- Create a temporary table to hold party guests
    CREATE TABLE #PartyGuests (
        GuestID INT IDENTITY(1,1),
        GuestName VARCHAR(100),
        IsBringingGift BIT
    )

    -- Insert some sample guests (replace with actual guests)
    INSERT INTO #PartyGuests (GuestName, IsBringingGift) VALUES
        ('Grandma', 1),
        ('Grandpa', 1),
        ('Aunt Sarah', 1),
        ('Uncle Bob', 0) -- Oops, Uncle Bob forgot the gift!

    -- Select the TOP 1 guest who is bringing a gift
    SELECT TOP 1 GuestName
    FROM #PartyGuests
    WHERE IsBringingGift = 1
    ORDER BY GuestID -- Assuming the first guest to arrive gets the prize

    -- Clean up the temporary table
    DROP TABLE #PartyGuests
END