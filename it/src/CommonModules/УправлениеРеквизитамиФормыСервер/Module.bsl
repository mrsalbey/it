
Процедура СоздатьРеквизитФормы(пФорма, ИмяРеквизита, ТипРеквизита, РодительРеквизита, ПутьРеквизита = "", 
	ВидРеквизита = "", Ф_Многострочность = Ложь) Экспорт
	
	ЭлДобавления = пФорма.Элементы.Добавить(ИмяРеквизита,ТипРеквизита,РодительРеквизита);
	
	Если ПутьРеквизита <> "" Тогда
		ЭлДобавления.ПутьКДанным = ПутьРеквизита;	
	КонецЕсли; 
	
	Если пФорма.Объект.Ссылка.Метаданные().Реквизиты.Найти(ИмяРеквизита) <> Неопределено Тогда
		ЭлДобавления.Заголовок = пФорма.Объект.Ссылка.Метаданные().Реквизиты[ИмяРеквизита].Синоним;	
	КонецЕсли; 
	
	Если ВидРеквизита <> "" Тогда
		ЭлДобавления.Вид = ВидРеквизита;	
	КонецЕсли; 
	
	Если Ф_Многострочность Тогда
		ЭлДобавления.МногострочныйРежим = Ф_Многострочность;	
	КонецЕсли; 
	
КонецПроцедуры

Процедура СоздатьРеквизитВТЧФормы(пФорма, ИмяРеквизита, ТипРеквизита, РодительРеквизита, ПутьРеквизита = "", 
	ВидРеквизита = "", Ф_Многострочность = Ложь) Экспорт
	
	ЭлДобавления = пФорма.Элементы.Добавить(ИмяРеквизита,ТипРеквизита,РодительРеквизита);
	
	ИмяТЧ = Прав(ПутьРеквизита, СтрДлина(ПутьРеквизита) - Найти(ПутьРеквизита,"."));
	ИмяТЧ = Лев(ИмяТЧ, Найти(ИмяТЧ,".")-1);
	
	Если ПутьРеквизита <> "" Тогда
		ЭлДобавления.ПутьКДанным = ПутьРеквизита;	
	КонецЕсли; 
	
	Если пФорма.Объект.Ссылка.Метаданные().ТабличныеЧасти[ИмяТЧ].Реквизиты.Найти(ИмяРеквизита) <> Неопределено Тогда
		ЭлДобавления.Заголовок = пФорма.Объект.Ссылка.Метаданные().ТабличныеЧасти[ИмяТЧ].Реквизиты.Найти(ИмяРеквизита).Синоним;	
	КонецЕсли; 
	
	Если ВидРеквизита <> "" Тогда
		ЭлДобавления.Вид = ВидРеквизита;	
	КонецЕсли; 
	
	Если Ф_Многострочность Тогда
		ЭлДобавления.МногострочныйРежим = Ф_Многострочность;	
	КонецЕсли; 
	
КонецПроцедуры

Процедура СоздатьРеквизитВТЗФормы(пФорма, ИмяРеквизита, ТипРеквизита, РодительРеквизита, ПутьРеквизита = "", 
	ВидРеквизита = "", Ф_Многострочность = Ложь) Экспорт
	
	ЭлДобавления = пФорма.Элементы.Добавить(ИмяРеквизита,ТипРеквизита,РодительРеквизита);
	
	Если ВидРеквизита <> "" Тогда
		ЭлДобавления.Вид = ВидРеквизита;	
	КонецЕсли; 
	
	Если Ф_Многострочность Тогда
		ЭлДобавления.МногострочныйРежим = Ф_Многострочность;	
	КонецЕсли; 
	
КонецПроцедуры

Процедура СоздатьГруппуФормы(пФорма, ИмяРеквизита, ТипРеквизита, РодительРеквизита, ВидГруппы,
	ГруппПодчЭФ) Экспорт
	
	ЭлДобавления = пФорма.Элементы.Добавить(ИмяРеквизита,ТипРеквизита,РодительРеквизита);
	
	ЭлДобавления.Вид 			= ВидГруппы;
	ЭлДобавления.Группировка 	= ГруппПодчЭФ;
	
КонецПроцедуры

Процедура СоздатьКнопкуФормы(пФорма, ИмяРеквизита, ТипРеквизита, РодительРеквизита, ИмяКоманды, ЗаголовокКоманды) Экспорт
	
	КомандаДобавления = пФорма.Команды.Добавить(ИмяКоманды);
	КомандаДобавления.Действие 	= ИмяКоманды;
	КомандаДобавления.Заголовок = ЗаголовокКоманды;
	
	ЭлДобавления = пФорма.Элементы.Добавить(ИмяРеквизита,ТипРеквизита,РодительРеквизита);
	
	ЭлДобавления.ИмяКоманды = ИмяКоманды;
	ЭлДобавления.Заголовок 	= ЗаголовокКоманды;
	
КонецПроцедуры
