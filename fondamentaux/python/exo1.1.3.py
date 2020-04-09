def estPalindrome(string):
    string = string.replace(" ", "")
    for i in range(0, len(string) // 2):
        if string[i] != string[len(string) - i - 1]:
         return "False"
    return "True"
