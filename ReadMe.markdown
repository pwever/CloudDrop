CloudDrop
=========

A webapp for quick file sharing via a obfuscated link.

1. Upload a file or zip archive.
2. Optionally provide a password that is used to encrypt the zip archive.
3. Share the resulting link (ie http://drop.domain.com/1aa2c6eab4321cdedf48eee2ade2a0215c7313e8).

There are very few security considerations. The server admin can look at files fairly easily, and the optional password is being transmitted non-securely. Ergo - sensitive material should be encrypted before it is uploaded.

Files are deleted after two weeks.


Screengrabs
-----------

![](https://lh5.googleusercontent.com/-0-84GylpRXs/Uc8Fr_MT2II/AAAAAAAAYMk/BS-1_Pig0TI/w438-h382-no/Filedrop-start.jpg)

![](https://lh5.googleusercontent.com/-JnsEOVQw9tM/Uc8FrmewDJI/AAAAAAAAYMc/otMbRFwX-iI/w438-h382-no/Filedrop-feedback.jpg)



Future developments
-------------------

* Automate archive deletion process with a cron job or equivalent.
