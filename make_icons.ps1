Add-Type -AssemblyName System.Drawing

function New-Icon {
    param(
        [int]$Size,
        [string]$Path
    )

    $bmp = New-Object System.Drawing.Bitmap($Size, $Size)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias

    # Background: near-black
    $bgBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 10, 10, 12))
    $g.FillRectangle($bgBrush, 0, 0, $Size, $Size)

    # Rounded square panel (slightly raised)
    $pad = [int]($Size * 0.06)
    $r = [int]($Size * 0.14)
    $rectSize = $Size - ($pad * 2)
    $gp = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = $r * 2
    $gp.AddArc($pad, $pad, $d, $d, 180, 90)
    $gp.AddArc($pad + $rectSize - $d, $pad, $d, $d, 270, 90)
    $gp.AddArc($pad + $rectSize - $d, $pad + $rectSize - $d, $d, $d, 0, 90)
    $gp.AddArc($pad, $pad + $rectSize - $d, $d, $d, 90, 90)
    $gp.CloseFigure()
    $panelBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 23, 23, 27))
    $g.FillPath($panelBrush, $gp)

    # Red diagonal accent stripe (bottom-left to top-right)
    $stripeBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        (New-Object System.Drawing.Point(0, $Size)),
        (New-Object System.Drawing.Point($Size, 0)),
        [System.Drawing.Color]::FromArgb(255, 226, 28, 52),
        [System.Drawing.Color]::FromArgb(255, 165, 21, 42)
    )
    $g.SetClip($gp)
    $stripePath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $sw = $Size * 0.22
    $pts = @(
        (New-Object System.Drawing.PointF(0, $Size)),
        (New-Object System.Drawing.PointF($Size, 0)),
        (New-Object System.Drawing.PointF($Size, $sw)),
        (New-Object System.Drawing.PointF($sw, $Size))
    )
    $stripePath.AddPolygon($pts)
    $g.FillPath($stripeBrush, $stripePath)
    $g.ResetClip()

    # Border
    $borderPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 226, 28, 52)), ($Size * 0.012)
    $g.DrawPath($borderPen, $gp)

    # Letter mark "G" centered
    $fontSize = $Size * 0.46
    $font = New-Object System.Drawing.Font("Arial", $fontSize, [System.Drawing.FontStyle]::Bold)
    $textBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $rectF = New-Object System.Drawing.RectangleF(0, ($Size * -0.02), $Size, $Size)
    $g.DrawString("G", $font, $textBrush, $rectF, $sf)

    $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
}

New-Icon -Size 512 -Path "C:\Users\Admin\Desktop\mano-gitara-web\icons\icon-512.png"
New-Icon -Size 192 -Path "C:\Users\Admin\Desktop\mano-gitara-web\icons\icon-192.png"
New-Icon -Size 180 -Path "C:\Users\Admin\Desktop\mano-gitara-web\icons\icon-180.png"

Write-Output "Icons generated."
