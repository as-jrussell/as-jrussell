$random = Get-Random -Minimum 0 -Maximum 10;
$names= Get-Content "C:\PowerShell\Games\Games_1.txt";
$targetWord = $names[$random];
[Char[]]$wordProgress =  "_" * $targetWord.Length
Clear-Host;

Write-Host "---------Guess the word--------------";

$life=5;
$guesses=@()
do
{
    do
    {
        Write-Host "[$($targetWord.Length)] $wordProgress";
        Write-Host "Lifes Remain " $life

        $guessLetter = Read-Host "Guess a letter:"
        if ($guesses -contains $guessLetter)
        {
            "Try another letter!"
        }
    } while ($guesses -contains $guessLetter) 

    $guesses+=$guessLetter
    $guesses -join ','

    $foundLetter = $false
    for($i=0;$i -lt $targetWord.Length; $i++)
    {
        if($guessLetter -like $targetWord[$i] )
        {
            $wordProgress[$i] = $guessLetter
            $foundLetter=$true
        }
    }

    if(!$foundLetter)
    {
        $life--;
    }

    if($($wordProgress -join '') -like $targetWord)
    {
        Write-Host $targetWord;
        Write-Host " ************  You WIN  ********************";
        break;
    }

}
while($life -gt 0)
if ($life -eq 0)
{
Write-Host " ------------- You LOST ------------"
}