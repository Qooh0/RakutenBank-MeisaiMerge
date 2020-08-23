# 一つの引数に複数の値を受け取りたい場合 [string[]] とする。, で分けて設定できる
param(
    [Parameter(Mandatory=$true, Position = 0)][string]$MeisaiFile,
    [string]$jcb,
    [string]$visa
)

$OutputFile = "output.csv"

Set-ExecutionPolicy Unrestricted -Scope Process -Force

function ShowUsage {
    Write-Output "Usage : ./Main.ps1 meisai.csv -jcb xxxx.csv -visa xxxx.csv"
}

function Main {
    # Write-Output $MeisaiFile
    # Write-Output $DebitFiles
    Copy-Item $MeisaiFile $OutputFile

    $jcbDebit = Import-Csv -Encoding oem $jcb
    $visaDebit = Import-Csv -Encoding oem $visa

    $output = Import-Csv -Encoding oem $OutputFile
    $output | ForEach-Object {
        #write-output $($_ | Where-Object{ $_.入出金先内容 -match "JCB.+[A|B](?<Num>.*)" }).入出金先内容
        #write-output $([regex]::match($_.入出金先内容, 'JCB.+[A|B](.*)').Value)
        if ($_.入出金先内容 -match 'JCB.+[A|B](?<num>.*)'){
            $jcbNumber = $Matches['num']
            $jcbData = $jcbDebit | Where-Object { $_.承認番号 -eq $jcbNumber }
            if ($null -eq $jcbData) {   # JCB のデータにない場合は、払い戻しされているはずなので、楽天の明細データから探す
                # 一旦手作業
            } else {
                # JCB のデータにあったので、$output に追記
                $_ | Add-Member -MemberType NoteProperty -Name ご利用先 -Value $jcbData.ご利用先
                $_ | Add-Member -MemberType NoteProperty -Name ポイント利用分 -Value $jcbData.ポイント利用分
            }
        } elseif ($_.入出金先内容 -match 'VISA.+[A|B](?<num>.*)'){
            $visaNumber = [int]$Matches['num']  # ここは文字列じゃなくて、数値
            $visaData = $visaDebit | Where-Object { $_.承認番号 -eq $visaNumber }
            if ($null -eq $visaData) {   # JCB のデータにない場合は、払い戻しされているはずなので、楽天の明細データから探す
                # 一旦手作業
            } else {
                # VISA のデータにあったので、$output に追記
                $_ | Add-Member -MemberType NoteProperty -Name ご利用先 -Value $visaData.ご利用先
                $_ | Add-Member -MemberType NoteProperty -Name ポイント利用分 -Value $visaData.ポイント利用分
            }
        }
    }
    $output | Export-csv -Encoding oem -Force -Path $OutputFile
}

Main
