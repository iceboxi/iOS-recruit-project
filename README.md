## 架構想法
1. iPad 與 iPhoe 除了 flow layout 差異外，其餘部份應盡可能reuse
2. cell 除了樣式差異以外，內容完全相同，故顯示邏輯上應reuse
3. iPad 在分割畫面下，若寬度不足的狀況下，應以 iPhone 樣式顯示，以達到更佳的使用者體驗
4. 為了降低 Controller 與 Model 間的耦合，使用 ViewModel 作為兩者之介接

## Model
1. Codable，依據 data 的 json 內容直接 Mapping
2. 為了保有彈性，category 採用 String 格式而非 Enum，在後續新增類別時，可直接顯示預設名稱而不需等待 app 更新

## Test
1. session mock 使用 local data 進行 model 相關測試
2. 可對 view model 進行驗證

## Third Party
1. SDWebImage: 用來做列表圖片下載，有 cache 機制