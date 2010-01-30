   .text
   .globl _convert

_convert:
   fctid  f1, f1
   fctid  f2, f2
   fctid  f3, f3
   fctid  f4, f4
   fctid  f5, f5
   fctid  f6, f6

   stfd  f1, 0(r3)
   stfd  f2, 8(r3)
   stfd  f3, 16(r3)
   stfd  f4, 24(r3)
   stfd  f5, 32(r3)
   stfd  f6, 40(r3)

   blr
