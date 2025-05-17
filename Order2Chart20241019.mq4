//+------------------------------------------------------------------+
//|                                                Order2Chart.mq4/5 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024 HaoWei"
#property version "1.0"
#property strict

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots 1

//#include <MT4Orders.mqh>
//#include <StdLibErr.mqh>






input int ID=-1;

input color BuyColor=clrDeepSkyBlue;
input color SellColor=clrDeepPink;
input int Width=3;




long ChartIDLong;
void OnInit(){
	
	ChartIDLong=ChartID();
}


void OnDeinit(const int reason){
	
	DeleteLine("Order2Chart",TimeCurrent());
}


int Objectsith;
void DeleteLine(string myName,datetime myDateTime){
	
	for(Objectsith=ObjectsTotal(ChartIDLong,0,-1)-1;Objectsith>=0;Objectsith--){
		if(StringFind(ObjectName(ChartIDLong,Objectsith,0,-1),myName)>-1 && (datetime)ObjectGetInteger(ChartIDLong,ObjectName(ChartIDLong,Objectsith,0,-1),OBJPROP_TIME,0)<=myDateTime){
			ObjectDelete(ChartIDLong,ObjectName(ChartIDLong,Objectsith,0,-1));
		}
	}
}


int ith;
string NameStr;
void DrawOrder(){
	
	for(ith=(OrdersHistoryTotal()-1);ith>=0;ith--){
		if(OrderSelect(ith,SELECT_BY_POS,MODE_HISTORY)==true && (ID==OrderMagicNumber() || ID<0)){
			if(StringCompare(OrderSymbol(),Symbol())==0){
				
				if(OrderType()==OP_BUY){
					NameStr="Order2Chart "+TimeToString(OrderOpenTime(),TIME_DATE|TIME_MINUTES|TIME_SECONDS)+" "+(string)OrderTicket()+" "+OrderComment();
					ObjectCreate(ChartIDLong,NameStr,OBJ_TREND,0,
					OrderOpenTime(),
					OrderOpenPrice(),
					OrderCloseTime(),
					OrderClosePrice()
					);
					
					ObjectSetInteger(ChartIDLong,NameStr,OBJPROP_COLOR,BuyColor);
					
					ObjectSetString(ChartIDLong,NameStr,OBJPROP_TEXT,DoubleToString((OrderClosePrice()-OrderOpenPrice())/SymbolInfoDouble(OrderSymbol(),SYMBOL_POINT),0));
					
					ObjectSetInteger(ChartIDLong,NameStr,OBJPROP_RAY_RIGHT,false);
					ObjectSetInteger(ChartIDLong,NameStr,OBJPROP_WIDTH,Width);
					
					ObjectSetInteger(ChartIDLong,NameStr,OBJPROP_SELECTABLE,false);
					ObjectSetInteger(ChartIDLong,NameStr,OBJPROP_SELECTED,false);
					
					ObjectSetInteger(ChartIDLong,NameStr,OBJPROP_HIDDEN,true);
					ObjectSetInteger(ChartIDLong,NameStr,OBJPROP_BACK,false);
				}
				if(OrderType()==OP_SELL){
					NameStr="Order2Chart "+TimeToString(OrderOpenTime(),TIME_DATE|TIME_MINUTES|TIME_SECONDS)+" "+(string)OrderTicket()+" "+OrderComment();
					ObjectCreate(ChartIDLong,NameStr,OBJ_TREND,0,
					OrderOpenTime(),
					OrderOpenPrice(),
					OrderCloseTime(),
					OrderClosePrice()
					);
					
					ObjectSetInteger(ChartIDLong,NameStr,OBJPROP_COLOR,SellColor);
					
					ObjectSetString(ChartIDLong,NameStr,OBJPROP_TEXT,DoubleToString((OrderOpenPrice()-OrderClosePrice())/SymbolInfoDouble(OrderSymbol(),SYMBOL_POINT),0));
					
					ObjectSetInteger(ChartIDLong,NameStr,OBJPROP_RAY_RIGHT,false);
					ObjectSetInteger(ChartIDLong,NameStr,OBJPROP_WIDTH,Width);
					
					ObjectSetInteger(ChartIDLong,NameStr,OBJPROP_SELECTABLE,false);
					ObjectSetInteger(ChartIDLong,NameStr,OBJPROP_SELECTED,false);
					
					ObjectSetInteger(ChartIDLong,NameStr,OBJPROP_HIDDEN,true);
					ObjectSetInteger(ChartIDLong,NameStr,OBJPROP_BACK,false);
				}
			}
		}
	}
}


int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],const double &open[],const double &high[],const double &low[],const double &close[],const long &tick_volume[],const long &volume[],const int &spread[]){
	
	DrawOrder();
	
	return(rates_total);
}