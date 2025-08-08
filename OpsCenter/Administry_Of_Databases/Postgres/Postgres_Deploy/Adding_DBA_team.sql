set role dba_team; 

-- 🔧 Create users and assign them to the dba_team role
SELECT deploy.SetAccountSetup(
    p_usernames := ARRAY[
        'jrussell',
        'acummins',
        'hbrotherton',
        'lrensberger',
        'mbreitsch'
    ],
    p_user_inherit_roles := ARRAY['dba_team'],
    p_execute_flag := TRUE
);


