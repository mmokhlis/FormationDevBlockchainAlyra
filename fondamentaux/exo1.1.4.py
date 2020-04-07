import math
class Cercle:

  def __init__(self, rayon):
      self.rayon = rayon

  def aire(self):
    return math.pi * self.rayon**2

  def perimetre(self):
      return 2 * math.pi * self.rayon

c = Cercle(5)
print({'aire': c.aire(), 'perimetre': c.perimetre()})