<?php
$smtpUsername=file_get_contents("/var/run/secrets/".getenv('SMTP_USERNAME_SECRET')) or die('SMTP Username not set');
$smtpPasswordRaw=file_get_contents("/var/run/secrets/".getenv('SMTP_PASSWORD_SECRET')) or die('SMTP Password not set');
$smtpPassword=\Civi::service('crypto.token')->encrypt($smtpPasswordRaw, 'CRED');
$formValues=[
"outBound_option"=>CRM_Mailing_Config::OUTBOUND_OPTION_SMTP,
"smtpServer"=>getenv('SMTP_HOST'),
"smtpPort"=>getenv('SMTP_PORT'),
"smtpAuth"=>true,
"smtpUsername"=>$smtpUsername,
"smtpPassword"=>$smtpPassword
];
Civi::settings()->set('mailing_backend', $formValues);
