<?php
$wgExternalDataSources['DW_BBB'] = [
    'server' => 'postgres',
    'type' => 'postgres',
    'name' => 'unita-datawarehouse',
    'user' => getenv('DATABASE_USERNAME'),
    'password' => getenv('DATABASE_PASSWORD'),
    'prepared'  => <<<'POSTGRE'
SELECT TO_TIMESTAMP(datacloud_activities.timestamp::integer)::date AS timestampfix, *
FROM datacloud_activities
WHERE type='bbb'
LIMIT 500;
POSTGRE
];

$wgExternalDataSources['DW_poll'] = [
    'server' => 'postgres',
    'type' => 'postgres',
    'name' => 'unita-datawarehouse',
    'user' => getenv('DATABASE_USERNAME'),
    'password' => getenv('DATABASE_PASSWORD'),
    'prepared'  => <<<'POSTGRE'
SELECT TO_TIMESTAMP(datacloud_activities.timestamp::integer)::date AS timestampfix, *
FROM datacloud_activities
WHERE object_type='poll'
LIMIT 500;
POSTGRE
];

$wgExternalDataSources['DW_files'] = [
    'server' => 'postgres',
    'type' => 'postgres',
    'name' => 'unita-datawarehouse',
    'user' => getenv('DATABASE_USERNAME'),
    'password' => getenv('DATABASE_PASSWORD'),
    'prepared'  => <<<'POSTGRE'
SELECT TO_TIMESTAMP(datacloud_activities.timestamp::integer)::date AS timestampfix, *
FROM datacloud_activities
WHERE object_type='files'
LIMIT 500;
POSTGRE
];

$wgExternalDataSources['DW_form'] = [
    'server' => 'postgres',
    'type' => 'postgres',
    'name' => 'unita-datawarehouse',
    'user' => getenv('DATABASE_USERNAME'),
    'password' => getenv('DATABASE_PASSWORD'),
    'prepared'  => <<<'POSTGRE'
SELECT TO_TIMESTAMP(datacloud_activities.timestamp::integer)::date AS timestampfix, *
FROM datacloud_activities
WHERE object_type='form'
LIMIT 500;
POSTGRE
];

$wgExternalDataSources['DW_cal'] = [
    'server' => 'postgres',
    'type' => 'postgres',
    'name' => 'unita-datawarehouse',
    'user' => getenv('DATABASE_USERNAME'),
    'password' => getenv('DATABASE_PASSWORD'),
    'prepared'  => <<<'POSTGRE'
SELECT TO_TIMESTAMP(datacloud_activities.timestamp::integer)::date AS timestampfix, *
FROM datacloud_activities
WHERE object_type='calendar'
LIMIT 500;
POSTGRE
];
?>