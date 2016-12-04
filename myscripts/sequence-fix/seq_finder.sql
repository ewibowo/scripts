SELECT ns.nspname AS schema_name, seq.relname AS seq_name
FROM pg_class AS seq
JOIN pg_namespace ns ON (seq.relnamespace=ns.oid)
WHERE seq.relkind = 'S'
  AND NOT EXISTS (SELECT * FROM pg_depend WHERE objid=seq.oid AND deptype='a')
ORDER BY seq.relname;
