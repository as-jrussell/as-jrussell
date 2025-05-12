use [Test1]

IF OBJECT_ID('dbo.CoffeeProtocol') IS NOT NULL
    DROP PROCEDURE dbo.CoffeeProtocol;
GO

CREATE PROCEDURE dbo.CoffeeProtocol
    @EnableSarcasm BIT = 1,
    @CoffeeCount INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Today VARCHAR(10) = DATENAME(WEEKDAY, GETDATE());
    DECLARE @Mood VARCHAR(100);
    DECLARE @StupidityTolerance INT;

    PRINT 'Launching ...';
    PRINT 'Today is: ' + @Today;

    -- Set tolerance level based on day
    IF @Today = 'Monday'
    BEGIN
        PRINT 'It is Monday... caffeine is no longer optional.';
        SET @StupidityTolerance = 25;
    END
    ELSE IF @Today = 'Friday'
    BEGIN
        PRINT 'It is Friday! Pretending to care at an all-time low.' 
		PRINT'Under no circumstances should production databases be touched; the weekend is approaching';
        SET @StupidityTolerance = 80;
    END
        ELSE IF @Today = 'Tuesday'
    BEGIN
        PRINT 'The worst day of the wwek! Tomorrow is not Friday, the day after that is not Friday! Pretending to care at an all-time low.';
        SET @StupidityTolerance = 80;
    END
	ELSE IF @Today = 'Thursday'
    BEGIN
        PRINT 'Friday Eve! We are almost there! Pretending to care still at an all-time low.';
        SET @StupidityTolerance = 80;
    END
    ELSE
    BEGIN
        PRINT 'Midweek detected. Proceed with moderate expectations.';
        SET @StupidityTolerance = 50;
    END

    -- Simulate coffee intake
    DECLARE @i INT = 0;
    WHILE @i < @CoffeeCount
    BEGIN
        PRINT 'Brewing coffee cup ' + CAST(@i + 1 AS VARCHAR) + ' of ' + CAST(@CoffeeCount AS VARCHAR) + '...';
        SET @i += 1;
        WAITFOR DELAY '00:00:01';
    END

    -- Mood diagnostics
    IF @EnableSarcasm = 1
    BEGIN
        IF @CoffeeCount = 0
            SET @Mood = 'System failure: No caffeine detected.';
        ELSE IF @CoffeeCount = 1 
            SET @Mood = 'Functional, but don''t ask for favors.';
        ELSE IF @CoffeeCount BETWEEN 2 AND 3
            SET @Mood = 'Running hot. Smart remarks likely.';
        ELSE
            SET @Mood = 'Overclocked. Expect brutal honesty and unnecessary opinions.';
    END
    ELSE
    BEGIN
        SET @Mood = 'Mood stable. Sarcasm filter engaged.';
    END

    -- Output final diagnostics
    PRINT 'Mood Scan: ' + @Mood;
    PRINT 'Stupidity Tolerance Level: ' + CAST(@StupidityTolerance AS VARCHAR) + '%';
    PRINT 'Protocol complete. You are cleared to ignore unreasonable requests.';
END
GO
