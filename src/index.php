<?php 


# phpinfo();
require_once './vendor/autoload.php';
?>
<form action="/?submit">
  <input type="text" name="seed" value="<?php echo $_REQUEST['seed']; ?>" placeholder="Enter base32 seed...">&nbsp;
  <input type="text" name="issuer" value="<?php echo $_REQUEST['issuer']; ?>" placeholder="Issuer...">&nbsp;
  <input type="text" name="label" value="<?php echo $_REQUEST['label']; ?>" placeholder="Label...">&nbsp;
  <input type="submit" value="Submit">
</form>
<?php 
use OTPHP\TOTP;
if(!empty($_REQUEST['seed'])){
	$totp = TOTP::create(str_replace(" ", "", strtoupper($_REQUEST['seed'])));
	$totp->setIssuer($_REQUEST['issuer']);
	$totp->setLabel($_REQUEST['label']);
	
	echo 'The current OTP is: '.$totp->now().'<br />';;
	echo 'The provisioning URL is: '. $totp->getProvisioningUri().'<br />';
	//echo 'Secret is: '. $totp->getSecret().'<br />';
	$googleChartUri = $totp->getQrCodeUri();
	echo "<img src='{$googleChartUri}'>";
}