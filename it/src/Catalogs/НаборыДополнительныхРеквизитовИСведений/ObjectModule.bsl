#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		УправлениеСвойствамиСлужебный.ПередЗаписьюГруппыНаборовСвойств(ЭтотОбъект);
	Иначе
		// Удаление дублей и пустых строк.
		ВыбранныеСвойства = Новый Соответствие;
		УдаляемыеСвойства = Новый Массив;
		
		// Дополнительные реквизиты.
		Для каждого ДополнительныйРеквизит Из ДополнительныеРеквизиты Цикл
			
			Если ДополнительныйРеквизит.Свойство.Пустая()
			 ИЛИ ВыбранныеСвойства.Получить(ДополнительныйРеквизит.Свойство) <> Неопределено Тогда
				
				УдаляемыеСвойства.Добавить(ДополнительныйРеквизит);
			Иначе
				ВыбранныеСвойства.Вставить(ДополнительныйРеквизит.Свойство, Истина);
			КонецЕсли;
		КонецЦикла;
		
		Для каждого УдаляемоеСвойство Из УдаляемыеСвойства Цикл
			ДополнительныеРеквизиты.Удалить(УдаляемоеСвойство);
		КонецЦикла;
		
		ВыбранныеСвойства.Очистить();
		УдаляемыеСвойства.Очистить();
		
		// Дополнительные сведения.
		Для каждого ДополнительноеСведение Из ДополнительныеСведения Цикл
			
			Если ДополнительноеСведение.Свойство.Пустая()
			 ИЛИ ВыбранныеСвойства.Получить(ДополнительноеСведение.Свойство) <> Неопределено Тогда
				
				УдаляемыеСвойства.Добавить(ДополнительноеСведение);
			Иначе
				ВыбранныеСвойства.Вставить(ДополнительноеСведение.Свойство, Истина);
			КонецЕсли;
		КонецЦикла;
		
		Для каждого УдаляемоеСвойство Из УдаляемыеСвойства Цикл
			ДополнительныеСведения.Удалить(УдаляемоеСвойство);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи()
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Родитель) Тогда
		ОсновнойОбъект = Родитель.ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(ОсновнойОбъект.Ссылка);
		ОсновнойОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли