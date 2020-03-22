import redis
# A simple snippet to get a list len of redis


def create_conn():
    redis_host = ["192.168.100.152"]
    redis_pass = "stevenux"
    conn_pool = redis.ConnectionPool(host=redis_host[0],
                                     port="6379",
                                     db=1,
                                     password=redis_pass)
    redis_conn = redis.Redis(connection_pool=conn_pool)
    return redis_conn


def get_len():
    redis_key = ['syslog_from_filebeat']
    list_len = create_conn().llen(redis_key[0])
    print("The len of key {} is {}".format(redis_key[0], list_len))


def main():
    create_conn()
    get_len()


if __name__ == '__main__':
    main()
