import os
os.rename("/opt/mssql/bin/sqlservr", "/opt/mssql/bin/sqlservr.old")
oldfile = open("/opt/mssql/bin/sqlservr.old", "rb").read()
newfile = oldfile.replace("\x00\x94\x35\x77", "\x00\x80\x84\x1e")
open("/opt/mssql/bin/sqlservr", "wb").write(newfile)
exit()