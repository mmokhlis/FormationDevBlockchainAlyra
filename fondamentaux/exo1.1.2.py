import random


userRand = int(input("Recherche par l'ordi \n"))

rand = random.randint(0, 100)


while rand != userRand:
    print("Ma proposition est ", rand)
    rand = random.randint(0, 100)

print("La réponse était ", rand)