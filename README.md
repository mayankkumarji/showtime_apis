# README

## Ruby version

- ruby 2.5.0

## System dependencies
```sh
#install all dependencies
$ bundle install
```
## Configuration

- setup database.yml

- create database

- set host url lib/job_api_caller.rb(currently set localhost:3000)

## How to run the rspec
```sh
$ rspec
```

## How to call api
* Api-Endpoints.
1) one is for listing jobs with pagination
2) another one is for creating jobs
note: There is one more endpoint which is for process job. it takes array of job ids and process that jobs if they are in waiting state.

## Endpoints
- listing-page GET [/api/v1/jobs](/api/v1/jobs)
- listing-page with pagination GET [/api/v1/jobs?page[number]=1](/api/v1/jobs?page[number]=1)

- create job POST [/api/v1/jobs](/api/v1/jobs)
 Body attributes name(required), priority(required), triggered_at(optional)

- process-job [/api/v1/jobs/process_job?job_id[]=2&job_id[]=1](/api/v1/jobs/process_job?job_id[]=2&job_id[]=1)

## List waiting/queue jobs based on order and priority
```sh
Job.waiting.get_by_priority
```

## How to create jobs by rails terminal
* There is a library called(JobCreation) to create jobs

```sh
JobCreation.new({:name=>"test", :priority=>"low"}).create_job
```
Note: Above job will be processed immediately after created because no run time is provided and its created by rails terminal.


```sh
JobCreation.new({:name=>"test", :priority=>"low", :triggered_at=> '18/11/2021 07:08'}).create_job
```
Note: Above job will be processed at run time provided(triggered_at) by user.

## How to invoke specfic jobs by rails terminal
```sh
Job.last.invoke_job
```
or
```sh
Job.first.invoke_job
```
## Docker Setup

* build docker image

```sh
docker build . -t <IMAGE_NAME>
```

* run docker container
```sh
docker run -it -p 3000:3000 <IMAGE_NAME>:latest
```