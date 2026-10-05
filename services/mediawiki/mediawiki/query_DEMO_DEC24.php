<?php

// This file and queries were created for the December 2024 demo of UNITApedia
// This demo focuded on one selected task (Task 5.1) to demonstrate the capability and end concept of UNITApedia and its dashboards

$wgExternalDataSources['DW_UNITAData_DEMODEC24_39'] = [
    'server' => 'postgres',
    'type' => 'postgres',
    'name' => 'unita-data-demo',
    'user' => getenv('DATABASE_USERNAME'),
    'password' => getenv('DATABASE_PASSWORD'),
    'prepared'  => <<<'POSTGRE'
SELECT * FROM indic_unita.indic_39
ORDER BY entry_id ASC;
POSTGRE
];

$wgExternalDataSources['DW_UNITAData_DEMODEC24_35_YT'] = [
    'server' => 'postgres',
    'type' => 'postgres',
    'name' => 'unita-data-demo',
    'user' => getenv('DATABASE_USERNAME'),
    'password' => getenv('DATABASE_PASSWORD'),
    'prepared'  => <<<'POSTGRE'
SELECT * FROM indic_unita.indic_35_youtube
ORDER BY entry_id ASC;
POSTGRE
];

$wgExternalDataSources['DW_UNITAData_DEMODEC24_35_Insta'] = [
    'server' => 'postgres',
    'type' => 'postgres',
    'name' => 'unita-data-demo',
    'user' => getenv('DATABASE_USERNAME'),
    'password' => getenv('DATABASE_PASSWORD'),
    'prepared'  => <<<'POSTGRE'
SELECT * FROM indic_unita.indic_35_instagram
ORDER BY entry_id ASC;
POSTGRE
];

$wgExternalDataSources['DW_UNITAData_DEMODEC24_35_TotalFollowers'] = [
    'server' => 'postgres',
    'type' => 'postgres',
    'name' => 'unita-data-demo',
    'user' => getenv('DATABASE_USERNAME'),
    'password' => getenv('DATABASE_PASSWORD'),
    'prepared'  => <<<'POSTGRE'
SELECT entry_date, SUM(follower_number) as followers FROM indic_unita.indic_35_etl_follower
GROUP BY entry_date
ORDER BY entry_date;
POSTGRE
];
?>