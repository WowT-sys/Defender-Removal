$removeappx = @("SecHealthUI"); $provisioned = get-appxprovisionedpackage -online; $appxpackage = get-appxpackage -allusers; $eol = @()
$store = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore'
$users = @('S-1-5-18'); if (test-path $store) {$users += $((dir $store -ea 0 |where {$ -like 'S-1-5-21'}).PSChildName)}
foreach ($choice in $removeappx) { if ('' -eq $choice.Trim()) {continue}
  foreach ($appx in $($provisioned |where {$.PackageName -like "$choice"})) {
    $next = !1; foreach ($no in $skip) {if ($appx.PackageName -like "$no") {$next = !0}} ; if ($next) {continue}
    $PackageName = $appx.PackageName; $PackageFamilyName = ($appxpackage |where {$.Name -eq $appx.DisplayName}).PackageFamilyName
    ni "$store\Deprovisioned$PackageFamilyName" -force >''; $PackageFamilyName 
    foreach ($sid in $users) {ni "$store\EndOfLife$sid$PackageName" -force >''} ; $eol += $PackageName
    dism /online /set-nonremovableapppolicy /packagefamily:$PackageFamilyName /nonremovable:0 >''
    remove-appxprovisionedpackage -packagename $PackageName -online -allusers >''
  }
  foreach ($appx in $($appxpackage |where {$.PackageFullName -like "$choice"})) {
    $next = !1; foreach ($no in $skip) {if ($appx.PackageFullName -like "$no") {$next = !0}} ; if ($next) {continue}
    $PackageFullName = $appx.PackageFullName;
    ni "$store\Deprovisioned$appx.PackageFamilyName" -force >''; $PackageFullName
    foreach ($sid in $users) {ni "$store\EndOfLife$sid$PackageFullName" -force >''} ; $eol += $PackageFullName
    dism /online /set-nonremovableapppolicy /packagefamily:$PackageFamilyName /nonremovable:0 >''
    remove-appxpackage -package $PackageFullName -allusers >''
  }
}