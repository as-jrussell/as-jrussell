------ Find Runaway Checked Out Work Items (by Checked Out Date, then narrow down by User)
SELECT * FROM unitrac..WORK_ITEM
WHERE CHECKED_OUT_DT > '2015-03-06'
AND UPDATE_USER_TX = 'cberhow'
AND LOCK_ID = 255

------- Back up Work Items Prior To Update
SELECT * INTO UniTracHDStorage..Work_Item_cberhow835
FROM unitrac..WORK_ITEM
WHERE CHECKED_OUT_DT > '2015-03-06'
AND UPDATE_USER_TX = 'cberhow'

------- Null out some fields to Un-check them out
UPDATE  UniTrac..WORK_ITEM
SET     CHECKED_OUT_OWNER_ID = NULL ,
        CHECKED_OUT_DT = NULL ,
        LOCK_ID = CASE WHEN LOCK_ID = 255 THEN 1
                       ELSE LOCK_ID + 1
                  END ,
        UPDATE_USER_TX = 'script' ,
        UPDATE_DT = GETDATE()
WHERE   CHECKED_OUT_OWNER_ID = 835
        AND CHECKED_OUT_DT > '2015-03-06'
        

--------- Only use if one of fields get missed        
UPDATE UniTrac..WORK_ITEM
SET CHECKED_OUT_DT = NULL
WHERE ID IN (SELECT ID FROM UniTracHDStorage..Work_Item_cberhow835)        
        
