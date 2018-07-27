#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Перем ОграничениеДоступаНаУровнеЗаписейВключено; // Флажок изменения значения константы с Ложь на Истина.
//                                                  Используется в обработчике события ПриЗаписи.

Перем ОграничениеДоступаНаУровнеЗаписейИзменено; // Флажок изменения значения константы.
//                                                  Используется в обработчике события ПриЗаписи.

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОграничениеДоступаНаУровнеЗаписейВключено
		= Значение И НЕ Константы.ОграничиватьДоступНаУровнеЗаписей.Получить();
	
	ОграничениеДоступаНаУровнеЗаписейИзменено
		= Значение <>   Константы.ОграничиватьДоступНаУровнеЗаписей.Получить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОграничениеДоступаНаУровнеЗаписейИзменено Тогда
		
		УправлениеДоступомСлужебный.ПриИзмененииОграниченияДоступаНаУровнеЗаписей(
			ОграничениеДоступаНаУровнеЗаписейВключено);
	КонецЕсли;
	
КонецПроцедуры


#КонецЕсли