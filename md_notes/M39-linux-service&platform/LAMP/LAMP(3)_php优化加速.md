![](png/2019-12-16-10-43-41.png)
![](png/2019-12-16-10-44-02.png)
![](png/2019-12-16-10-44-33.png)
![](png/2019-12-16-10-44-49.png)
![](png/2019-12-16-10-45-04.png)
![](png/2019-12-16-10-45-44.png)



```bash
MariaDB [(none)]> CREATE USER wordpress;
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> CREATE DATABASE wordpress;
Query OK, 1 row affected (0.00 sec)

MariaDB [(none)]> GRANT ALL ON wordpress.* TO wordpress@'*' IDENTIFIED BY 'wordpress';
Query OK, 0 rows affected (0.00 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.00 sec)
```