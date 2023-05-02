<?php
$elems=[
'activityDate'=>60,
'birth'=>120,
'searchDate'=>80
];
foreach($elems as $k=>$v)
{
$datePref=new CRM_Core_DAO_PreferencesDate();
if($datePref->get('name',$k))
{
$datePref->start=$v;
$datePref->save();
echo $k.' has been set to '.$v.PHP_EOL;
}
else
{
echo "Key not found : ".$k.PHP_EOL;
}
}
try {
$flushResult=civicrm_api3('System','flush',[]);
echo "Flush Result : ".PHP_EOL;
var_dump($flushResult);
}
catch(CiviCRM_API3_Exception $e)
{
echo $e->getMessage();
echo $e->getTraceAsString();
}
