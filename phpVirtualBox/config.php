<?php
/**
 * phpVirtualBox example configuration. 
 * @version $Id: config.php-example 585 2015-04-04 11:39:31Z imoore76 $
 *
 * rename to config.php and edit as needed.
 *
 */
class phpVBoxConfig {
    /* Username / Password for system user that runs VirtualBox */
    var $username = 'user';
    var $password = 'pass';
    var $location = 'http://192.168.0.15:18083/';
    //// Multiple servers example config. Uncomment (remove /* and */) to use.
    //// Add ALL the servers you want to use. Even if you have the server set
    //// above. The default server will be the first one in the list.
    /*
    var $servers = array(
	    array(
		    'name' => 'VboxServer',
		    'username' => 'user',
		    'password' => 'pass',
		    'location' => 'http://192.168.0.15:18083/',
		    'authMaster' => true // Use this server for authentication
	    ),
	    array(
		    'name' => 'Second_server',
		    'username' => 'user',
		    'password' => 'pass',
		    'location' => 'http://192.168.0.14:18083/'
	    ),
    );
    */
}
?>
