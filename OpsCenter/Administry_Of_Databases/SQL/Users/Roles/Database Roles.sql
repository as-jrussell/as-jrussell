select r.name as Role, m.name as Principal

from

    master.sys.server_role_members rm

    inner join

    master.sys.server_principals r on r.principal_id = rm.role_principal_id and r.type = 'R'

    inner join

    master.sys.server_principals m on m.principal_id = rm.member_principal_id