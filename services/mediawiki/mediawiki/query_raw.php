<?php 
$wgExternalDataSources['DW_BIP_Output_For_Page'] = [
    'server' => 'postgres',
    'type' => 'postgres',
    'name' => 'impact-study',
    'user' => 'postgres',
    'password' => 'CyZfp0quY8wqogPgJKa7',
    'prepared' => <<<'POSTGRE'
SELECT id, ubi, ipg, unizar, upna, usmb, unito, unibs,
       uvt, unitbv, hes_so, chnu, total, name, uppa
FROM public."bip-outputs"
WHERE name = $1
POSTGRE
];?>