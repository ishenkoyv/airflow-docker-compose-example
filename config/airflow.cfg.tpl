[core]
# The home folder for airflow, default is ~/airflow
airflow_home = {{ AIRFLOW_HOME }}

# The folder where your airflow pipelines live, most likely a
# subfolder in a code repository
dags_folder = {{ AIRFLOW_DAGS_DIR }}

# The folder where airflow should store its log files. This location
base_log_folder = {{ AIRFLOW_HOME }}/logs

# Airflow can store logs remotely in AWS S3 or Google Cloud Storage. Users
# must supply a remote location URL (starting with either 's3://...' or
# 'gs://...') and an Airflow connection id that provides access to the storage
# location.
remote_base_log_folder =
remote_log_conn_id =

# Use server-side encryption for logs stored in S3
encrypt_s3_logs = False
# deprecated option for remote log storage, use remote_base_log_folder instead!
# s3_log_folder =

# The executor class that airflow should use. Choices include
# SequentialExecutor, LocalExecutor, CeleryExecutor
executor = CeleryExecutor

# The SqlAlchemy connection string to the metadata database.
# SqlAlchemy supports many different database engine, more information
# their website
sql_alchemy_conn = {{ SQLALCHEMY_DATABASE_URI }}

# The SqlAlchemy pool size is the maximum number of database connections
# in the pool.
sql_alchemy_pool_size = 5

# The SqlAlchemy pool recycle is the number of seconds a connection
# can be idle in the pool before it is invalidated. This config does
# not apply to sqlite.
sql_alchemy_pool_recycle = 3600

# The amount of parallelism as a setting to the executor. This defines
# the max number of task instances that should run simultaneously
# on this airflow installation
parallelism = 32

# The number of task instances allowed to run concurrently by the scheduler
dag_concurrency = 16

# Are DAGs paused by default at creation
dags_are_paused_at_creation = True

# When not using pools, tasks are run in the "default pool",
# whose size is guided by this config element
non_pooled_task_slot_count = 128

# The maximum number of active DAG runs per DAG
max_active_runs_per_dag = 16

# Whether to load the examples that ship with Airflow. It's good to
# get started, but you probably want to set this to False in a production
# environment
load_examples = True

# Where your Airflow plugins are stored
plugins_folder = {{ AIRFLOW_HOME }}/plugins

# Secret key to save connection passwords in the db
# FIXME
fernet_key = {{ AIRFLOW_FERNET_KEY }}

# Whether to disable pickling dags
donot_pickle = False

# How long before timing out a python file import while filling the DagBag
dagbag_import_timeout = 30

[webserver]
# The base url of your website as airflow cannot guess what domain or
# cname you are using. This is use in automated emails that
# airflow sends to point links to the right web server
base_url = http://localhost:8080

# The ip specified when starting the web server
web_server_host = 0.0.0.0

# The port on which to run the web server
web_server_port = 8080

# The time the gunicorn webserver waits before timing out on a worker
web_server_worker_timeout = 120

# Secret key used to run your flask app
# FIXME
secret_key = some_very_secret_key

# Number of workers to run the Gunicorn web server
workers = 4

# The worker class gunicorn should use. Choices include
# sync (default), eventlet, gevent
worker_class = sync

# Expose the configuration file in the web server
expose_config = true

# Set to true to turn on authentication : http://pythonhosted.org/airflow/installation.html#web-authentication
authenticate = False

# Filter the list of dags by owner name (requires authentication to be enabled)
filter_by_owner = False

[email]
email_backend = airflow.utils.email.send_email_smtp

[smtp]
# If you want airflow to send emails on retries, failure, and you want to
# the airflow.utils.send_email function, you have to configure an smtp
# server here
# FIXME
smtp_host = localhost
smtp_starttls = True
smtp_ssl = False
smtp_user = airflow
smtp_port = 25
smtp_password = airflow
smtp_mail_from = airflow@airflow.local

[celery]
# This section only applies if you are using the CeleryExecutor in
# [core] section above

# The app name that will be used by celery
celery_app_name = airflow.executors.celery_executor

# The concurrency that will be used when starting workers with the
# "airflow worker" command. This defines the number of task instances that
# a worker will take, so size up your workers based on the resources on
# your worker box and the nature of your tasks
celeryd_concurrency = 16

# When you start an airflow worker, airflow starts a tiny web server
# subprocess to serve the workers local log files to the airflow main
# web server, who then builds pages and sends them to users. This defines
# the port on which the logs are served. It needs to be unused, and open
# visible from the main web server to connect into the workers.
worker_log_server_port = 8793

# The Celery broker URL. Celery supports RabbitMQ, Redis and experimentally
# a sqlalchemy database. Refer to the Celery documentation for more
# information.
broker_url = {{ REDIS_URI }}


# Another key Celery setting
celery_result_backend = {{ REDIS_URI }}

# Celery Flower is a sweet UI for Celery. Airflow has a shortcut to start
# it `airflow flower`. This defines the IP that Celery Flower runs on
flower_host = {{ FLOWER_HOST }}

# Celery Flower is a sweet UI for Celery. Airflow has a shortcut to start
# it `airflow flower`. This defines the port that Celery Flower runs on
flower_port = 5555

# Default queue that tasks get assigned to and that worker listen on.
default_queue = default

[scheduler]
# Task instances listen for external kill signal (when you clear tasks
# from the CLI or the UI), this defines the frequency at which they should
# listen (in seconds).
job_heartbeat_sec = 5

# The scheduler constantly tries to trigger new tasks (look at the
# scheduler section in the docs for more information). This defines
# how often the scheduler should run (in seconds).
scheduler_heartbeat_sec = 5

# Statsd (https://github.com/etsy/statsd) integration settings
# statsd_on =  False
# statsd_host =  localhost
# statsd_port =  8125
# statsd_prefix = airflow

# The scheduler can run multiple threads in parallel to schedule dags.
# This defines how many threads will run. However airflow will never
# use more threads than the amount of cpu cores available.
max_threads = 2

[mesos]
# Mesos master address which MesosExecutor will connect to.
master = localhost:5050

# The framework name which Airflow scheduler will register itself as on mesos
framework_name = Airflow

# Number of cpu cores required for running one task instance using
# 'airflow run <dag_id> <task_id> <execution_date> --local -p <pickle_id>'
# command on a mesos slave
task_cpu = 1

# Memory in MB required for running one task instance using
# 'airflow run <dag_id> <task_id> <execution_date> --local -p <pickle_id>'
# command on a mesos slave
task_memory = 256

# Enable framework checkpointing for mesos
# See http://mesos.apache.org/documentation/latest/slave-recovery/
checkpoint = False

# Failover timeout in milliseconds.
# When checkpointing is enabled and this option is set, Mesos waits
# until the configured timeout for
# the MesosExecutor framework to re-register after a failover. Mesos
# shuts down running tasks if the
# MesosExecutor framework fails to re-register within this timeframe.
# failover_timeout = 604800

# Enable framework authentication for mesos
# See http://mesos.apache.org/documentation/latest/configuration/
authenticate = False

# Mesos credentials, if authentication is enabled
# default_principal = admin
# default_secret = admin
