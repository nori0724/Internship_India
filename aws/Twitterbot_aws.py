import requests
import json
import pandas as pd
import datetime
import numpy as np
import matplotlib.pyplot as plt
from fbprophet import Prophet
import twitter
import os
#import pystan

def calc_aqi(x):
    if 0<=x & x<=15.4:
        pm_min=0.0
        pm_max=15.4
        aqi_min=0.0
        aqi_max=50
        
    elif 15.5<=x & x<=40.4:
        pm_min=15.5
        pm_max=40.4
        aqi_min=51.0
        aqi_max=100.0
        
    elif 40.5<=x & x<=65.4:
        pm_min=40.5
        pm_max=65.4
        aqi_min=101.0
        aqi_max=150.0
        
    elif 65.5<=x & x<=150.4:
        pm_min=65.5
        pm_max=150.4
        aqi_min=151.0
        aqi_max=200.0
        
    elif 150.5<=x & x<=250.4:
        pm_min=150.5
        pm_max=250.4
        aqi_min=201.0
        aqi_max=300.0
        
    elif 250.5<=x :
        pm_min=250.5
        pm_max=500.4
        aqi_min=301.0
        aqi_max=500
    
    return pm_min, pm_max, aqi_min, aqi_max

def main():
    #----------Get the data via API----------

    url="https://api.aqi.in/getexceldata"
    payload={"serialno":"PLLODA000406", "time":"4", "slottype":"2"}
    r=requests.get(url, headers=payload)

    jsondata=r.json()

    aqi_in=jsondata["data"][1]["avrangearray"]
    pm25=jsondata["data"][2]["avrangearray"]
    timearray=jsondata["data"][7]["timearray"]

    #Create dataframe
    df=pd.DataFrame({
        "time":timearray,
        "AQI-IN":aqi_in,
        "pm25":pm25
    })


    #----------Data processing----------

    df["time"]=df["time"].str[:-5]+"00:00"

    start_string=df.iloc[-1,0]
    #datetime to string
    start_datetime=datetime.datetime.strptime(start_string, '%Y-%m-%d %H:%M:%S')
    #string to datetime
    starttime=start_datetime.strftime("%Y%m%d")


    end_string=df.iloc[0,0]
    #datetime to string
    end_datetime=datetime.datetime.strptime(end_string, '%Y-%m-%d %H:%M:%S')
    #1 day add
    end_add_datetime=end_datetime + datetime.timedelta(days=1)
    #string to datetime
    endtime=end_add_datetime.strftime("%Y%m%d")

    #fill missing value
    df_datetime=pd.DataFrame()
    df_datetime["time"]=pd.date_range(start=starttime, end=endtime, freq="H").astype("str")[:-1]
    df=pd.merge(df_datetime, df, on="time", how="left")

    #Change type from string to datatime 
    df['time'] = pd.to_datetime(df['time'])

    #Set index
    df = df.set_index('time')
    df.head()

    df["pm25"]=df["pm25"].astype("float64")

    #Plot
    #There are some missing values
    #plt.figure(figsize=(16,9))
    #plt.plot(df["pm25"])
    #plt.show()


    #----------Create model----------

    train =df.reset_index()[["time", "pm25"]].rename(columns={'time':'ds', 'pm25':'original_y'})
    #Normalization
    train["y"]=np.log(train["original_y"])
        
    #Set cap and floor in the train data
    train["cap"]=np.log(700)
    train["floor"]=0

    #Create model
    model = Prophet(growth='logistic', daily_seasonality=False)
    model.add_seasonality(name='daily', period=7, fourier_order=90) 
    model.add_seasonality(name='weekly', period=7, fourier_order=50) 
    model.fit(train)


    # ----------Forecast---------

    #Forecast 168hours later
    future = model.make_future_dataframe(periods=24, freq="H")
        
    #Set cap and floor in the forecast data
    future["cap"]=np.log(600)
    future["floor"]=0
        
    #Forecast
    forecast = model.predict(future)
    forecast["yhat"]=np.exp(forecast["yhat"])
    forecast=forecast[["ds", "yhat"]].iloc[len(train):,:]
    
    #Calculate aqi value
    pm_value=forecast["yhat"]
    pm_obs=round(pm_value.mean(), 0)
    pm_min, pm_max, aqi_min, aqi_max=calc_aqi(int(pm_obs))
    aqi_values=int(round((pm_obs - pm_min) * (aqi_max - aqi_min) / (pm_max - pm_min) + aqi_min, 0))
    
    #Plot
    filename="/home/ubuntu/twitter/img/{}.png".format(datetime.datetime.now().strftime('forecast_%m_%d'))

    now=datetime.datetime.now()
    now=now.strftime('%dth %B %Y')
    train_series=train["original_y"]
    train_series.index=train["ds"]
    forecast_series=forecast["yhat"]
    forecast_series.index=forecast["ds"]

    fig=plt.figure(figsize=(16,9))
    plt.title("Forecast on "+now)
    plt.plot(forecast_series[0:24], color="r", label="forecast")
    plt.legend()
    fig.savefig(filename)


    #----------LINE push----------

    url = os.environ["https://notify-api.line.me/api/notify"]
    access_token = os.environ["PtL9u0EOIYzU4RrQP6hxQkhpjKa1UxvAx6ugu4ztrUH"]
    headers = {'Authorization': 'Bearer ' + access_token}

    message = "Forecast on "+now
    image = filename  # png or jpg
    payload = {'message': message}
    files = {'imageFile': open(image, 'rb')}
    r = requests.post(url, headers=headers, params=payload, files=files,)
    
    #----------Twitter bot----------
    '''
    auth = twitter.OAuth(consumer_key=os.environ["CONSUMER_KEY"],
    consumer_secret=os.environ["CONSUMER_SECRET"],
    token=os.environ["ACCESS_TOKEN_KEY"],
    token_secret=os.environ["ACCESS_TOKEN_SECRET"])

    t = twitter.Twitter(auth=auth)

    #Tweet
    status="Air Quality Forecast for today, "+ now+". " +"\n"+"[New Delhi] AQI: {0}, PM2.5: {1} μg/m\u00b3".format(aqi_values, pm_obs) + "\n"+ "\n"+"For detailed data: www.aqi.in" + "\n" +"#airquality #pollution #MyAQI #airqualityindex #AQI"+ "\n" +"Air quality robot by Rahul Singh."
    #img pass
    pic = filename
    with open(pic,"rb") as image_file:
        image_data=image_file.read()
    pic_upload = twitter.Twitter(domain='upload.twitter.com',auth=auth)
    id_img1 = pic_upload.media.upload(media=image_data)["media_id_string"]
    t.statuses.update(status=status, media_ids=", ".join([id_img1]))
    '''
    
    

if __name__=='__main__':
    main()