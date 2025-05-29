DROP PROCEDURE IF EXISTS CoffeeProtocol;

CREATE OR REPLACE PROCEDURE CoffeeProtocol(
    IN EnableSarcasm BOOLEAN DEFAULT TRUE,
    IN CoffeeCount INTEGER DEFAULT 0
)
LANGUAGE plpgsql
AS $$
DECLARE
    Today TEXT := TO_CHAR(CURRENT_DATE, 'Day');
    Mood TEXT;
    StupidityTolerance INTEGER;
    i INTEGER := 0;
BEGIN
    RAISE NOTICE 'Launching ...';
    RAISE NOTICE 'Today is: %, and caffeine level is %', TRIM(Today), CoffeeCount;

    -- Set tolerance level based on the day
    IF TRIM(Today) = 'Monday' THEN
        RAISE NOTICE 'It is Monday... caffeine is no longer optional.';
        StupidityTolerance := 25;
    ELSIF TRIM(Today) = 'Friday' THEN
        RAISE NOTICE 'It is Friday! Pretending to care at an all-time low.';
        RAISE NOTICE 'Under no circumstances should production databases be touched; the weekend is approaching';
        StupidityTolerance := 80;
    ELSIF TRIM(Today) = 'Tuesday' THEN
        RAISE NOTICE 'The worst day of the week! Tomorrow is not Friday, the day after that is not Friday!';
        StupidityTolerance := 80;
    ELSIF TRIM(Today) = 'Thursday' THEN
        RAISE NOTICE 'Friday Eve! We are almost there!';
        StupidityTolerance := 80;
    ELSE
        RAISE NOTICE 'Midweek detected. Proceed with moderate expectations.';
        StupidityTolerance := 50;
    END IF;

    -- Simulate coffee intake
    WHILE i < CoffeeCount LOOP
        RAISE NOTICE 'Brewing coffee cup % of %...', i + 1, CoffeeCount;
        PERFORM pg_sleep(1); -- 1 second delay
        i := i + 1;
    END LOOP;

    -- Mood diagnostics
    IF EnableSarcasm THEN
        IF CoffeeCount = 0 THEN
            Mood := 'System failure: No caffeine detected.';
        ELSIF CoffeeCount = 1 THEN
            Mood := 'Functional, but don''t ask for favors.';
        ELSIF CoffeeCount BETWEEN 2 AND 3 THEN
            Mood := 'Running hot. Smart remarks likely.';
        ELSE
            Mood := 'Overclocked. Expect brutal honesty and unnecessary opinions.';
        END IF;
    ELSE
        Mood := 'Mood stable. Sarcasm filter engaged.';
    END IF;

    -- Output final diagnostics
    RAISE NOTICE 'Mood Scan: %', Mood;
    RAISE NOTICE 'Stupidity Tolerance Level: %%%', StupidityTolerance;
    RAISE NOTICE 'Protocol complete. You are cleared to ignore unreasonable requests.';
END;
$$;
