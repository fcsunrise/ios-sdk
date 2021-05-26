# AtlasSDK
### Зависимости
Для комфортной работы сдк использует следующие зависимости:

```ruby
Alamofire
Marshal
Promises
QuickLayout
```
### Установка
SDK может быть установлено через Cocoapods. В Podfile укажите следующее:
```ruby
pod 'SunriseAtlasSDK', :git => 'https://github.com/fcsunrise/ios-sdk.git'
```

### Начало работы
Перед началом работы с AtlasSDK следует передать следующие параметры (выдаются компанией Atlas): 

```swift
pointID

pointToken
```

#### Синтаксис:
 ```swift
AtlasSDK.shared.<имя переменной> 
```

#### Примечания:

Иногда для разных услуг может быть несколько вариантов pointID и pointToken в таком случае перед проведением услуги нужно заново изменять значения соответствующих переменных в SDK как показано выше.
### Конфигурация работы SDK

 * `locale` - переменная отвечающая за передаваемое значение “locale” платежному шлюзу Atlas. Возможные значения ua, en, ru. По дефолту указано ua.
 * `navigation` -  переменная отвечающая за текущий UINavigationController, используется SDK для автоматического показа контроллера оплат host-2-host, контроллера вебвью.
 * `callBackUrl` - переменная для ввода callbackURL. Клиент получит коллбэк на указанный при создании транзакции callbackURL.
 * `successUrl` - переменная для ввода successURL. Для коректной работы услуг обязательно укажите данную переменную. Клиент будет возвращен на полученный при создании транзакции successURL.
 * `failureUrl` - переменная для ввода failureURL. Для коректной работы услуг обязательно укажите данную переменную. Клиент будет возвращен на полученный при создании транзакции failureURL.
 * `delegate` - является базовым делегатом для работы с SDK.
 * `paymentLogo` - переменная для логотипа компании клиента, данный логотип будет использоваться в контроллере оплат host-2-host
 * `shouldShowWebControllerOnCardTokenization` - переменная отвечающая за показ контроллера с ссылкой pay_Url для продолжения услуги токенизации карты. true - SDK автоматически откроет контроллер с ссылкой, false - методу делегата будет передан ответ от сервера, содержащий данную ссылку. Метод делегата с ответом от сервера будет вызываться в независимости от значения данной переменной.
 * `shouldShowWebControllerOnWebAcquiringPayment` - переменная отвечающая за показ контроллера с ссылкой pay_Url для продолжения услуг веб эквайринга (веб эквайринг с токенизированной картой и без, оплаты без 3Ds  с токенизированной картой и без, мото платежи). true - SDK автоматически откроет контроллер с ссылкой, false - методу делегата будет передан ответ от сервера, содержащий данную ссылку. Метод делегата с ответом от сервера будет вызываться в независимости от значения данной переменной.
 * `shouldShowWebControllerOnHost2HostPayment` - переменная отвечающая за показ контроллера с ссылкой pay_Url для продолжения услуги host-2-host. true - SDK автоматически откроет контроллер с ссылкой, false - методу делегата будет передан ответ от сервера, содержащий данную ссылку. Метод делегата с ответом от сервера будет вызываться в независимости от значения данной переменной.

### AtlasSDKDelegate
При возникновении любой ошибки будет вызван метод делегата: 
 ```swift
func atlasSDKDidFail(with error: APIError, request: RequestType?)
``` 

При создании транзакции будет вызван метод делегата: 
 ```swift
func atlasSDKDidCreateTransaction(with data: CreateTransactionResponseData)
```

При успешном окончании любой из услуг и вызове метода поиска транзакции будет вызван метод делегата:
 ```swift
func atlasSDKDidFindTransaction(with data: FindTransactionResponseData)
```

При передаче платежным шлюзом ссылки подтверждения 3Ds при проведении услуги host-2-host будет вызван метод делегата. Данный метод является опциональным для реализации.
```swift
func atlasSDKDidReceive3DsOnHost2Host(paymentID: String, link: URL)
```

При передаче платежным шлюзом ссылки подтверждения 3Ds при проведении услуги moto будет вызван метод делегата. Данный метод является опциональным для реализации.
```swift
func atlasSDKDidReceive3DsOnMoto(paymentID: String, link: URL)
```

При успешном окончании услуг host-2-host, moto, веб эквайринга, оплат без 3Ds будет вызван метод делегата:
 ```swift
func atlasSDKDidCompleteTransaction(paymentID: String, externalTransactionID: Int?, oltpID: Int?)
```

При получении ссылки `pay_url` от платежного шлюза при проведении услуг host-2-host, веб эквайринга, оплат без 3Ds будет вызван метод делегата. Данный метод является опциональным для реализации.
 ```swift
func atlasSDKDidReceive(payUrl: URL, paymentID: String, for service: SDKServices)
```

### Услуга host-2-host
Для проведения услуги host-2-host AtlasSDK предлагает 2 решения: с использованием готового UI для введения данных карты и проведение услуги без участия готового UI с передачей данных карты соответствующим методам SDK.
Вне зависимости от метода проведения услуги host-2-host при успешном создании транзакции будет вызван метод делегата:
```swift
func atlasSDKDidCreateTransaction(with data: CreateTransactionResponseData)
```

Вне зависимости от метода проведения услуги host-2-host при успешном проведении транзакции будет вызван метод делегата:
 ```swift
func atlasSDKDidCompleteTransaction(paymentID: String, externalTransactionID: Int?, oltpID: Int?)
```
и
```swift
func atlasSDKDidFindTransaction(with data: FindTransactionResponseData)
```
#### Использование готового UI

Для вызова контроллера ввода данных карты и проведения оплаты host-2-host используется следующий метод:
```swift
func presentPaymentController(pointID: String, pointToken: String, account: String, serviceID: Int, amount: Int, controllerTitle: String?, style: UIModalPresentationStyle, completion: @escaping() -> ())
```

* `pointID` - выдается менеджером компании Atlas.
* `pointToken` - выдается менеджером компании Atlas.
* `account` - аккаунт пользователя, будет передан при создании транзакции в поле fields.
* `serviceID` - выдается менеджером компании Atlas.
* `amount` - сумма платежа в минимальных единицах (копейки).
* `controllerTitle` - желамый `title` контроллера оплат.
* `style` - стиль представления контроллера
* `completion` будет вызван после проведения валидации транзакции и показа самого контроллера.

При успешном завершении услуги host-2-host будут вызваны методы делегата указанные выше.
##### Синтаксис
AtlasSDK.shared.<имя метода>
##### Примечание
Данный контроллер вызывается методом UINavigationController present. При вызове метода для показа контроллера данные SDK pointID и pointToken будут изменены, если в подальшем вам нужно будет провести услуги по другим значениям этих данных, их следует изменить как указано в пункте “Начало работы”. Также значение переменной shouldShowWebControllerOnHost2HostPayment будет изменено на true.
#### Без использования готового UI
Проведение услуги host-2-host возможно при использовании данных карты, либо при использовании токена карты и её cvv кода. Для этого используются следующие методы:
```swift
func host2hostPayment(amount: Int, serviceID: Int, account: String, cardNumber: String, expirationMonth: String, expirationYear: String, cvv: String)

func host2hostTokenizedPayment(amount: Int, serviceID: Int, account: String, cardToken: String, cvv: String)
```

* `amount` - сумма платежа в минимальных единицах (копейки).
* `account` - аккаунт пользователя, будет передан при создании транзакции в поле fields.
* `serviceID` - выдается менеджером компании Atlas.
* `cardNumber` - номер карты (16 символов БЕЗ пробелов).
* `expirationMonth` - месяц истечения срока действия карты (2 символа, прим.: 08, 12, 10 и т.д.).
* `expirationYear` - год истечения срока действия карты (2 символа, прим.: 20, 21 и т.д.).
* `cvv` - cvv код карты (3 символа).
* `cardToken` - токен карты.
 
Далее следует ожидать вызова методов делегата указаных выше.
## Веб эквайринг
Услуга веб эквайринга может быть проведена без данных карты, либо с токенизированной картой. В зависимости от значения переменной shouldShowWebControllerOnWebAcquiringPayment при получении ссылки pay_url от платежного шлюза AtlasSDK может само показать контроллер с данной ссылкой, в любом случае будет вызван метод делегата с переданной ссылкой pay_url.
Для данной услуги используются методы AtlasSDK: 
```swift
func webAcquiringPayment(amount: Int, serviceID: Int, account: String)

func webAcquiringPaymentByTokenizedCard(amount: Int, serviceID: Int, account: String, cardToken: String, cvv: String)
```
* `amount` - сумма платежа в минимальных единицах (копейки).
* `account` - аккаунт пользователя, будет передан при создании транзакции в поле fields.
* `serviceID` - выдается менеджером компании Atlas.
* `cvv` - cvv код карты (3 символа).
* `cardToken` - токен карты.

#### Синтаксис
```swift
AtlasSDK.shared.
```

### Оплаты без 3Ds
Услуга оплаты без 3Ds может быть проведена с данными карты, либо с токенизированной картой. В зависимости от значения переменной shouldShowWebControllerOnWebAcquiringPayment при получении ссылки pay_url от платежного шлюза AtlasSDK может само показать контроллер с данной ссылкой, в любом случае будет вызван метод делегата с переданной ссылкой pay_url.
Для данной услуги используются методы AtlasSDK: 
``` swift
func payWithout3DsVerification(amount: Int, serviceID: Int, account: String, cardNumber: String, expirationMonth: String, expirationYear: String, cvv: String)

func payWithout3DsVerificationByTokenizedCard(amount: Int, serviceID: Int, account: String, cardToken: String, cvv: String)
```

* `amount` - сумма платежа в минимальных единицах (копейки).
* `account` - аккаунт пользователя, будет передан при создании транзакции в поле fields.
* `serviceID` - выдается менеджером компании Atlas.
* `cardNumber` - номер карты (16 символов БЕЗ пробелов).
* `expirationMonth` - месяц истечения срока действия карты (2 символа, прим.: 08, 12, 10 и т.д.).
* `expirationYear` - год истечения срока действия карты (2 символа, прим.: 20, 21 и т.д.).
* `cvv` - cvv код карты (3 символа).
* `cardToken` - токен карты.
#### Синтаксис
```swift
AtlasSDK.shared.<имя метода>
```
### Moto платеж
Услуга moto платежа проводится с данными карты. В зависимости от значения переменной shouldShowWebControllerOnWebAcquiringPayment при получении ссылки 3Ds от платежного шлюза AtlasSDK может само показать контроллер с данной ссылкой, в любом случае будет вызван метод делегата с переданной ссылкой 3Ds.

Для данной услуги используются методы AtlasSDK: 
```swift
func motoPayment(amount: Int, serviceID: Int, account: String, cardNumber: String, expirationMonth: String, expirationYear: String, cvv: String)
```
#### Синтаксис
```swift
AtlasSDK.shared.<имя метода>
```
### Токенизация карты
В зависимости от значения переменной shouldShowWebControllerOnWebAcquiringPayment при получении ссылки pay_url от платежного шлюза AtlasSDK может само показать контроллер с данной ссылкой, в любом случае будет вызван метод делегата с переданной ссылкой pay_url.
Для данной услуги используются методы AtlasSDK: 
```swift
func tokenizeCard(serviceID: Int, fields: JSONObject?)
```
* `serviceID` - выдается менеджером компании Atlas.
* `fields` - объект, который будет передан платежному шлюзу в поле fields (обычно там указывается account клиента).
#### Синтаксис
```swift
AtlasSDK.shared.<имя метода>
```
### Дополнительно
В AtlasSDK также есть метод для получения данных транзакции.
```swift
func findTransaction(paymentID: String?, externalTransactionID: Int?, oltpID: Int?, completion: @escaping(FindTransactionResponseData) -> Void)
```
