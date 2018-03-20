<?php  // Moodle configuration file

unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dbtype    = getenv("DBTYPE");
$CFG->dblibrary = 'native';
$CFG->dbhost    = getenv("DBHOST");
$CFG->dbname    = getenv("DBNAME");
$CFG->dbuser    = getenv("DBUSER");
$CFG->dbpass    = getenv("DBPASS");
$CFG->prefix    = getenv("MDLPREFIX");
$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => getenv("DBPORT"),
  'dbsocket' => getenv("DBSOCKET"),
  'dbcollation' => 'utf8mb4_general_ci',
);

$CFG->wwwroot   = getenv("WWWROOT");
$CFG->dataroot  = '/var/www/moodledata';
$CFG->admin     = 'admin';

$CFG->directorypermissions = 0777;

$CFG->lang = getenv('LANG');

@error_reporting(E_ALL | E_STRICT); // NOT FOR PRODUCTION SERVERS!
@ini_set('display_errors', '1');    // NOT FOR PRODUCTION SERVERS!
$CFG->debug = (E_ALL | E_STRICT);   // === DEBUG_DEVELOPER - NOT FOR PRODUCTION SERVERS!
$CFG->debugdisplay = 1;             // NOT FOR PRODUCTION SERVERS!

$CFG->tool_generator_users_password = 'Pass001!';

$CFG->defaulthomepage = 0;

$CFG->allowthemechangeonurl = true;

require_once(__DIR__ . '/lib/setup.php');

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!
