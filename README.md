## インターン概要<br>
- 会社名：[AQI.inc](https://www.aqi.in/)
- 期間：2019/09/16 ~ 2020/03(予定)
- 内容：<br>
      大気汚染の時系列解析<br>
      二酸化炭素濃度を用いた在室人数推定<br>
- 手法：<br>
      統計モデル(ARIMAモデル、状態空間モデル)<br>
      機械学習モデル<br>
      深層学習モデル(LSTM)<br>
      
## インターンの目的
#### なぜインドなのか
将来はグローバルに活躍できるデータサイエンティストになるのが僕の目標なので、海外でのインターンを探していました。もちろんアメリカシリコンバレーでのインターンに憧れはありましたが、
- 0を生み出した国、数学に強い  
- カーストや地理歴要因からオフショアとしてITが盛んだった過去がある  
- インドならではの厳しく制約のある環境から生み出されるリバースイノベーション  
- スタートアップ大国  
- ネクストチャイナと呼ばれる急成長中のインド市場  

上記のような観点に着目してインドのスタートアップに飛び込むことを決意しました。国として成長している環境に飛び込みそれを肌で感じ取ることは貴重な経験なのではないかと思っています。

#### インターンを通して成し遂げたいこと  
このインターンを通して成し遂げたいことは「自らの力でレールを引き自らの力で道を広げていくこと」です。僕は15人のスタートアップでインターンをしていますが、この会社を見つけるのにエージェントは通していません。自ら気になる会社にレジュメを付けたメールを送り自分をアピールしました。送ったメールの合計は100通を超えます。また、今までのインターンではあらかじめやるべき課題が用意されていましたが今回はありません。自ら提案する必要があります。そこで学生データサイエンティストとしてなかなか経験できない「企業にある様々な課題をデータサイエンスの課題に落とし込む」ところを特に経験したいと思っています。CEOへの課題ヒアリングや自らデータを観察しその上でデータサイエンスの課題に落とし込んでいきたいと思います。上記を達成するために留学の期間は6ヶ月にセットしました。まずは半分の3ヶ月で何らかのアウトプットを出すことを目標に取り組んでいきます。

## インターン進捗メモ(インドでの活動も含む)  
#### 3月  
- TwitterAPIの取得  
- 予測結果を自動的にツイートするTwitterbotの作成  
- PM2.5を用いたAQIの算出([詳細](https://www.epa.gov/sites/production/files/2014-05/documents/zell-aqi.pdf))  
- 環境変数の設定　　
- AWS Lambdaの設定  
- AWS LambdaにPythonをモジュール毎zipでアップロード  
- EC2上でのanacondaの環境構築  
- EC2上でのcrontabの設定    
- [アプリケーション開発者のための機械学習実践講座](https://www.udemy.com/course/ml_for_app_developers/)の受講  
#### 2月  
- Prophet, ARIMA, 状態空間モデルの作成  
- 同じデータを用いた精度評価、モデル間の精度比較  
- 精度評価方法の検討  
- crontabを用いた予測の定期実行  
- 予測結果のデータベースへの書き込み  
- まとめ、英語でのドキュメントの作成  
- meetupへの参加  
- [Explainable AI (XAI) Day at ODSC Delhi](https://www.meetup.com/ja-JP/Delhi-Data-Science-ODSC/events/268109108/)  
- [GDG Cloud New Delhi x Elastic: Data on Google Cloud Platform](https://www.meetup.com/ja-JP/gdgcloudnd/events/267374102/)  
#### 1月  
- 一時帰国・就活(12/26 ~ 1/15)  
- Rによる地理空間データの可視化  
- クリギングの理論  
- IT企業訪問  
#### 12月  
- ARIMAモデルの作成([進捗の詳細](https://github.com/nori0724/forecast_PM2.5/blob/master/model/ARIMA.md))  
- meetupへの参加  
  - [Google Coloud Community Day](https://commudle.com/gdgcloudnd/events/google-cloud-community-day)  
  
※3週間の食中毒を経験  

#### 11月
- 時系列解析の理論の勉強
  - [学部横断型教育プログラム「数理・データサイエンス教育プログラム」数理手法VII（時系列解析）2019年版北川源四郎](http://www.mi.u-tokyo.ac.jp/mds-oudan/lecture_document_2019_math7/time_series_analysis_2019.html)
- meetupへの参加  
  - [CellStrat AI Lab-Coding Hours - Machine Learning, Deep Learning & more (Gurgaon)](https://www.meetup.com/ja-JP/Disrupt-4-0/events/265652913/)  
  - [Demystifying Expedia ML/AI Ecosystem & UX Practices for Designing AI Application](https://www.meetup.com/ja-JP/Delhi-Data-Science-ODSC/events/265741225/)  
  - [PyData Delhi Meetup #35](https://www.meetup.com/ja-JP/PyDataDelhi/events/266436797/)  
- LSTMの修正
- 状態空間モデルの作成 
- クリギングを用いた空間補間  
- foliumを用いたpm2.5の可視化mapの作成  

#### 10月
- データの可視化  
- トレンド, 季節性の確認  
- 統計モデルの作成(ARIMA)  
- Deep Learningモデルの作成(LSTM) 
- 外部データの追加([FIRE INFORMATION FOR RESOURCE MANAGEMENT SYSTEM (FIRMS)](https://firms.modaps.eosdis.nasa.gov/))
  - PM2.5の変動には野焼きが関わっているため 
- ベイズの勉強
  - [【PythonとStanで学ぶ】仕組みが分かるベイズ統計学入門](https://www.udemy.com/course/pythonstan/)
- データコンペへの参加
  - [マイナビ × SIGNATE Student Cup 2019: 賃貸物件の家賃予測](https://signate.jp/competitions/182)
  - 詳細は[mynavi_competition](https://github.com/nori0724/mynavi_competition),[ブログ](https://masanori.hateblo.jp/entry/2019/11/08/175710)。 
- meetupへの参加
  - [Developing AI Solution Mindset & Intro to Meta Heuristics and it’s Applications](https://www.meetup.com/ja-JP/Delhi-Data-Science-ODSC/events/264951470/)  
- ハッカソンへの参加
  - [hackCBS 2.0](https://hackcbsv2.hackerearth.com/ja/)
    
#### 9月
- インターンの方針確認  
- CEOのビジョン共有  
  - どんなデータがあればそれが成し遂げられるかディスカッション
- 所持しているデータの確認
- スクレイピングの勉強
  - [PythonによるWebスクレイピング〜入門編〜【業務効率化への第一歩】](https://www.udemy.com/course/python-scraping-beginner/)
      
      
