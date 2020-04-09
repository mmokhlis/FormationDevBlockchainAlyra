import random

rand = random.randint(0, 100)

userRand = int(input("Devinez un nombre entre 1 et 100 \n"))


def cheekranduser(usernmb, truerand):

    if abs(usernmb-truerand) == 0:
        return "Exact!"
    elif abs(usernmb-truerand) <= 5:
        return "tres proche \n"
    elif abs(usernmb - truerand in range(6, 11)):
        return "proche \n"
    elif usernmb-truerand < 0:
        return "c'est bcp plus \n"
    else:
        return "c'est bcp moins \n"


cheek = cheekranduser(userRand, rand)

while cheek != "Exact!":
    cheek = cheekranduser(int(input(cheek)), rand)

print(cheek)