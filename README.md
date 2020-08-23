楽天銀行利用明細まとめ
=====================

RB-debitmeisai, RB-torihikimeisai をまとめるツール
現在のバージョンでは debitmeisai に、ご利用先、ポイント利用分の列のヘッダーを追記する必要がある

実行方法
=========

```
 .\Main.ps1 .\RB-torihikimeisai.csv -jcb .\RB-debitmeisai-jcb.csv -visa .\RB-debitmeisai-visa.csv
```

TODO
=====

承認番号の桁数が違う。VISA は6桁、JCB は7桁。

雑感
====

なぜかマッチしない支払いが VISA にあるのは、なぜなんだろう……。
