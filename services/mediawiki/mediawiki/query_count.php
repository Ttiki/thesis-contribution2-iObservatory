<?php
$wgExternalDataSources['DW_BBB_count'] = [
    // 'server' => 'datawarehouse',
    'server' => 'postgres',
    'type' => 'postgres',
    'name' => 'unita-dw',
    'user' => getenv('DATABASE_USERNAME'),
    'password' => getenv('DATABASE_PASSWORD'),
    'prepared'  => <<<'POSTGRE'
SELECT subject, TO_TIMESTAMP(datacloud_activities.timestamp::integer)::date AS timestampfix, COUNT(*) AS activity_count 
FROM datacloud_activities
WHERE datacloud_activities.type='bbb' AND datacloud_activities.subject='meeting_started'
GROUP BY timestampfix, subject
ORDER BY timestampfix;
POSTGRE
];

$wgExternalDataSources['DW_poll_count'] = [
    'server' => 'postgres',
    'type' => 'postgres',
    'name' => 'unita-dw',
    'user' => getenv('DATABASE_USERNAME'),
    'password' => getenv('DATABASE_PASSWORD'),
    'prepared'  => <<<'POSTGRE'
SELECT TO_TIMESTAMP(datacloud_activities.timestamp::integer)::date AS timestampfix, COUNT(*) AS activity_count
FROM datacloud_activities
WHERE datacloud_activities.type='vote_set' AND object_type='poll' 
GROUP BY timestampfix
ORDER BY timestampfix;
POSTGRE
];

$wgExternalDataSources['DW_files_count'] = [
    'server' => 'postgres',
    'type' => 'postgres',
    'name' => 'unita-dw',
    'user' => getenv('DATABASE_USERNAME'),
    'password' => getenv('DATABASE_PASSWORD'),
    'prepared'  => <<<'POSTGRE'
SELECT TO_TIMESTAMP(datacloud_activities.timestamp::integer)::date AS timestampfix, COUNT(*) AS activity_count
FROM datacloud_activities
WHERE datacloud_activities.type='file_created' AND object_type='files' 
GROUP BY timestampfix
ORDER BY timestampfix;
POSTGRE
];

$wgExternalDataSources['DW_form_count'] = [
    'server' => 'postgres',
    'type' => 'postgres',
    'name' => 'unita-dw',
    'user' => getenv('DATABASE_USERNAME'),
    'password' => getenv('DATABASE_PASSWORD'),
    'prepared'  => <<<'POSTGRE'
SELECT TO_TIMESTAMP(datacloud_activities.timestamp::integer)::date AS timestampfix, COUNT(*) AS activity_count
FROM datacloud_activities
WHERE datacloud_activities.type='forms_newsubmission' AND object_type='form' 
GROUP BY timestampfix
ORDER BY timestampfix;
POSTGRE
];

$wgExternalDataSources['DW_cal_count'] = [
    'server' => 'postgres',
    'type' => 'postgres',
    'name' => 'unita-dw',
    'user' => getenv('DATABASE_USERNAME'),
    'password' => getenv('DATABASE_PASSWORD'),
    'prepared'  => <<<'POSTGRE'
SELECT TO_TIMESTAMP(datacloud_activities.timestamp::integer)::date AS timestampfix, COUNT(*) AS activity_count
FROM datacloud_activities
WHERE datacloud_activities.type='calendar' AND object_type='calendar_event' 
GROUP BY timestampfix
ORDER BY timestampfix;
POSTGRE
];

$wgExternalDataSources['B4B_count'] = [
    'server' => 'postgres',
    'type' => 'postgres',
    'name' => 'unita-data',
    'user' => getenv('DATABASE_USERNAME'),
    'password' => getenv('DATABASE_PASSWORD'),
    'prepared'  => <<<'POSTGRE'
SELECT country, COUNT(country) AS count
FROM todel_bips
GROUP BY country;
POSTGRE
];
?>