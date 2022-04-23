$servers->newServer('ldap_pla');
$servers->setValue('server','name','OpenLDAP');
$servers->setValue('server','base', array('dc=inmylab,dc=de'));
$servers->setValue('login','bind_id','cn=admin,dc=inmylab,dc=de');