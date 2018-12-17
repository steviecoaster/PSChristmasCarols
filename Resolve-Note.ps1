function Resolve-Note {
    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias('♪', '♫')]
        [ValidateSet('C', 'C#', 'Db', 'D', 'D#', 'Eb', 'E', 'F', 'F#', 'Gb', 'G', 'G#', 'Ab', 'A', 'A#', 'Bb', 'B')]
        [string]
        $Note,

        [Parameter(Position = 1, ValueFromPipelineByPropertyName)]
        [ValidateRange(-4, 5)]
        [int]
        $Octave = 0,

        [Parameter(Position = 2, ValueFromPipelineByPropertyName)]
        [Alias('Length')]
        [ValidateSet('16', '8', '4', '4.', '2', '2.', '1')]
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
        }

        $NoteDuration = @{
            '16' = 125
            '8'  = 250
            '4'  = 500
            '4.' = 750
            '2'  = 1000
            '2.' = 1500
            '1'  = 2000
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

        $Duration = $NoteDuration[$NoteLength]

        if ($PSCmdlet.ShouldProcess(('BEEPing Pitch {0} Duration {1}' -f $Pitch, $Duration))) {
            [Console]::Beep($Pitch, $Duration)
        }
    }
}
