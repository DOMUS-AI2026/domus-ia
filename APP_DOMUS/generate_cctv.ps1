Add-Type -AssemblyName System.Drawing

function Create-DerivedCctv {
    param (
        [string]$SourcePath,
        [string]$TargetPath,
        [string]$CamTitle,
        [string]$SubTitle,
        [System.Drawing.Color]$ThemeColor,
        [bool]$AddDetectorBox = $false
    )

    $src = [System.Drawing.Bitmap]::FromFile($SourcePath)
    $bmp = New-Object System.Drawing.Bitmap($src.Width, $src.Height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

    # Flip horizontally for a different perspective
    $src.RotateFlip([System.Drawing.RotateFlipType]::RotateNoneFlipX)

    $rect = New-Object System.Drawing.Rectangle(0, 0, $src.Width, $src.Height)
    $g.DrawImage($src, $rect, 0, 0, $src.Width, $src.Height, [System.Drawing.GraphicsUnit]::Pixel)

    # Dark vignette tint
    $tintBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(60, $ThemeColor.R, $ThemeColor.G, $ThemeColor.B))
    $g.FillRectangle($tintBrush, $rect)

    # Surveillance HUD
    $fontHeader = New-Object System.Drawing.Font('Consolas', 20, [System.Drawing.FontStyle]::Bold)
    $fontSub = New-Object System.Drawing.Font('Consolas', 15, [System.Drawing.FontStyle]::Bold)
    $hudBrush = New-Object System.Drawing.SolidBrush($ThemeColor)
    $bgHudBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 5, 8, 14))

    # Top banner background
    $g.FillRectangle($bgHudBrush, 20, 20, 680, 45)
    $g.DrawString($CamTitle, $fontHeader, $hudBrush, 30, 28)

    # Bottom banner background
    $g.FillRectangle($bgHudBrush, 20, ($src.Height - 65), 580, 40)
    $g.DrawString($SubTitle, $fontSub, $hudBrush, 30, ($src.Height - 55))

    if ($AddDetectorBox) {
        $pen = New-Object System.Drawing.Pen($ThemeColor, 3)
        $pen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
        $g.DrawRectangle($pen, 180, 210, 320, 250)
        $g.FillRectangle($hudBrush, 180, 180, 190, 28)
        $fontTag = New-Object System.Drawing.Font('Consolas', 12, [System.Drawing.FontStyle]::Bold)
        $textDarkBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::Black)
        $g.DrawString('AREA DE MONITORAMENTO', $fontTag, $textDarkBrush, 185, 185)
        $pen.Dispose()
    }

    $g.Dispose()
    $src.Dispose()
    $bmp.Save($TargetPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Output "Created $TargetPath"
}

# 1. Banho Suíte from cctv_banheiro
Create-DerivedCctv -SourcePath 'a:\APP_DOMUS\assets\cctv_banheiro.png' `
                   -TargetPath 'a:\APP_DOMUS\assets\cctv_banhosuite.png' `
                   -CamTitle 'REC [● LIVE] CAM-09: BANHO SUITE' `
                   -SubTitle 'SENSOR ACQUA: 40 L/DIA · ILUM: NORMAL' `
                   -ThemeColor ([System.Drawing.Color]::FromArgb(255, 34, 230, 208)) `
                   -AddDetectorBox $true

# 2. Lavanderia from cctv_cozinha
Create-DerivedCctv -SourcePath 'a:\APP_DOMUS\assets\cctv_cozinha.png' `
                   -TargetPath 'a:\APP_DOMUS\assets\cctv_lavanderia.png' `
                   -CamTitle 'REC [● LIVE] CAM-10: LAVANDERIA / SERVICO' `
                   -SubTitle 'MAQ LAVAR: STANDBY · FLUXO: 0 L/H' `
                   -ThemeColor ([System.Drawing.Color]::FromArgb(255, 46, 204, 113)) `
                   -AddDetectorBox $true

# 3. Quarto 2 from cctv_quarto
Create-DerivedCctv -SourcePath 'a:\APP_DOMUS\assets\cctv_quarto.png' `
                   -TargetPath 'a:\APP_DOMUS\assets\cctv_quarto2.png' `
                   -CamTitle 'REC [● LIVE] CAM-07: QUARTO 2 / HOSPEDES' `
                   -SubTitle 'PRESENCA: AUSENTE · TEMP: 22.6 C' `
                   -ThemeColor ([System.Drawing.Color]::FromArgb(255, 245, 197, 66)) `
                   -AddDetectorBox $false

Write-Output 'All distinct CCTV images successfully generated!'
