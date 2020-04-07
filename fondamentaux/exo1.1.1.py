import random

rand = random.randint(0, 100)

userRand = int(input("Devinez un nombre entre 1 et 100 \n"))


def cheekranduser(usernmb, truerand):

    def cheekdistance(a, b):
        if abs(a-b) <= 5:
            return "tres proche \n"
        elif abs(usernmb - truerand in range(6, 11)):
            return "proche \n"
        elif a-b < 0:
            return "c'est bcp plus \n"
        else:
            return "c'est bcp moins \n"

    if usernmb == truerand:
        return "Exact!"
    else:
        return cheekdistance(usernmb, truerand)

cheek = cheekranduser(userRand, rand)

while cheek != "Exact!":
    cheek = cheekranduser(int(input(cheek)), rand)

print(cheek)