# README
Showcasing some of the work I have done in the past.   


## Prerequistes
- Need a Mac to run.   
- Install docker [Link to Install Docker](https://www.docker.com/get-started/)  

## Cloning the repo
To clone the repo copy the command below and paste it in your terminal:    
```
git clone git@github.com:guesswhat91/lrs_showcase.git
```

Go to the repo that was just cloned by copy the below command into the terminal window:    
```
cd lrs_showcase
```

## Building the docker image
Copy the command below in the terminal window:   
```
make build
```  
This will start to to build the docker image with all the dependencies.  

## Opening Jupyter
Once completed you can open up the jupyter notebook as a local host, copy the command below and paste it in the terminal window.  
```
make jupyter
```  
This will open up the jupyter notebook workspace. 

## Closing the container
Once all done copy and paste the command below in terminal:  
```
make stop
```
This will stop all containers. In addition the local web browser where jupyter is being hosted can be shut down at this time.  

