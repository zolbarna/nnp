<?php

#$ups_name = URL driven UPS name which has to be configuried under nut

$ups_name = $_GET['ups'];

$out = shell_exec("upsc $ups_name@127.0.0.1");

$lines = explode("\n",$out);

foreach ($lines as $thisline) {

        $values = explode(" ",$thisline);
#       echo $values[1]."\n";
        foreach ($values as $var) {
                if (is_numeric($values[1])){
                        echo "# HELP\n";
                        echo "# TYPE " .  $ups_name ."_". str_replace('.','_',trim($values[0],":")) . " gauge\n";
                        echo $ups_name ."_". str_replace('.','_',trim($values[0],":")) ." ". $values[1]."\n";
                        unset($values);
                } else {
#               echo $var . " is not numeric\n";
                }
        }
#       echo $thisline."\n";
}
#echo $out;
?>
