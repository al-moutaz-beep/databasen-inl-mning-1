# databasen-inl-mning-1
Al Moutaz Bllah 
YH25

Kund
 Sparar info om kunder.
 Epost = kundens ID (primärnyckel).


Bok
 Sparar info om böcker.
 ISBN = bokens ID (primärnyckel).


Bestallning
 En order som en kund gör.
 Ordernummer = orderns ID.
 KundEpost = kopplas till rätt kund (främmande nyckel till Kund).


Orderrad
 Vilka böcker som finns i en viss order.
 Har både Ordernummer (koppling till Bestallning)
 och ISBN (koppling till Bok).
 Tillsammans är de primärnyckel.


Så: Kund gör Bestallning,
 Bestallning har flera Orderrad,
 varje Orderrad pekar på en Bok.
