function Resolve-Note {
    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias('♪', '♫')]
        [ValidateSet('C', 'C#', 'Db', 'D', 'D#', 'Eb', 'E', 'F', 'F#', 'Gb', 'G', 'G#', 'Ab', 'A', 'A#', 'Bb', 'B', '-')]
        [string]
        $Note,

        [Parameter(Position = 1, ValueFromPipelineByPropertyName)]
        [ValidateRange(-4, 5)]
        [int]
        $Octave = 0,

        [Parameter(Position = 2, ValueFromPipelineByPropertyName)]
        [Alias('Length')]
        [ValidateScript(
            {
                $_ -match '(64|32|16|8|4|2|1).*'
            }
        )]
        [ArgumentCompleter(
            {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
                return @('1','2','4','8','16','32','64') -match "^$WordToComplete"
            }
        )]
        [string]
        $NoteLength = '4',

        [Parameter()]
        [Alias('BPM')]
        [ValidateRange(0, 300)]
        [int]
        $BeatsPerMinute = 120
    )
    begin {
        $BaseNoteFrequencies = @{
            'C'  = 261.626
            'C#' = 277.183
            'Db' = 277.183
            'D'  = 293.665
            'D#' = 311.127
            'Eb' = 311.127
            'E'  = 329.628
            'F'  = 349.228
            'F#' = 369.994
            'Gb' = 369.994
            'G'  = 391.995
            'G#' = 415.305
            'Ab' = 415.305
            'A'  = 440
            'A#' = 466.164
            'Bb' = 466.164
            'B'  = 493.883
            '-'  = 37
        }

        $NoteDuration = @{
            '64' = 0.25
            '32' = 0.5
            '16' = 1
            '8'  = 2
            '4'  = 4
            '2'  = 8
            '1'  = 16
        }
    }
    process {
        $Pitch = switch ($Octave) {
            {$_ -lt 0} {
                $BaseNoteFrequencies[$Note] / [Math]::Pow(2, - $Octave)
            }
            {$_ -gt 0} {
                $BaseNoteFrequencies[$Note] * [Math]::Pow(2, $Octave)
            }
            0 {
                $BaseNoteFrequencies[$Note]
            }
        }
        
        if ($NoteLength -match '\.') {
            $DotCount = ($NoteLength -replace '[^\.]').Length
            $Multiplier = [Math]::Pow( 1.5, $DotCount )
        }
        else {
            $Multiplier = 1
        }
        
        $DurationScale = $NoteDuration[$NoteLength -replace '\.']
        $Duration = $DurationScale * $Multiplier * $BeatsPerMinute

        if ($DurationScale -ge 1) {
            $beep = "b$('e' * $DurationScale)p"
        }
        elseif ($DurationScale -eq 0.5) {
            $beep = 'bp'
        }
        else {
            $beep = 'b'
        }
        
        if ($PSCmdlet.ShouldProcess(('[{0} Hz] {1}' -f $Pitch, $beep))) {
            [Console]::Beep($Pitch, $Duration)
        }
    }
}
