class ChangeStateCodeToState < ActiveRecord::Migration
  def up
    execute <<-SQL
    UPDATE tags SET 
        context = 'State',
        name = CASE name
            WHEN 'AL' THEN 'Alabama - AL'
            WHEN 'AK' THEN 'Alaska - AK'
            WHEN 'AS' THEN 'American Samoa - AS'
            WHEN 'AZ' THEN 'Arizona - AZ'
            WHEN 'AR' THEN 'Arkansas - AR'
            WHEN 'CA' THEN 'California - CA'
            WHEN 'CO' THEN 'Colorado - CO'
            WHEN 'CT' THEN 'Connecticut - CT'
            WHEN 'DE' THEN 'Delaware - DE'
            WHEN 'DC' THEN 'District of Columbia - DC'
            WHEN 'FL' THEN 'Florida - FL'
            WHEN 'GA' THEN 'Georgia - GA'
            WHEN 'HI' THEN 'Hawaii - HI'
            WHEN 'ID' THEN 'Idaho - ID'
            WHEN 'IL' THEN 'Illinois - IL'
            WHEN 'IN' THEN 'Indiana - IN'
            WHEN 'IA' THEN 'Iowa - IA'
            WHEN 'KS' THEN 'Kansas - KS'
            WHEN 'KY' THEN 'Kentucky - KY'
            WHEN 'LA' THEN 'Louisiana - LA'
            WHEN 'ME' THEN 'Maine - ME'
            WHEN 'MD' THEN 'Maryland - MD'
            WHEN 'MA' THEN 'Massachusetts - MA'
            WHEN 'MI' THEN 'Michigan - MI'
            WHEN 'MN' THEN 'Minnesota - MN'
            WHEN 'MS' THEN 'Mississippi - MS'
            WHEN 'MO' THEN 'Missouri - MO'
            WHEN 'MT' THEN 'Montana - MT'
            WHEN 'NE' THEN 'Nebraska - NE'
            WHEN 'NV' THEN 'Nevada - NV'
            WHEN 'NH' THEN 'New Hampshire - NH'
            WHEN 'NJ' THEN 'New Jersey - NJ'
            WHEN 'NM' THEN 'New Mexico - NM'
            WHEN 'NY' THEN 'New York - NY'
            WHEN 'NC' THEN 'North Carolina - NC'
            WHEN 'ND' THEN 'North Dakota - ND'
            WHEN 'OH' THEN 'Ohio - OH'
            WHEN 'OK' THEN 'Oklahoma - OK'
            WHEN 'OR' THEN 'Oregon - OR'
            WHEN 'PA' THEN 'Pennsylvania - PA'
            WHEN 'PR' THEN 'Puerto Rico - PR'
            WHEN 'RI' THEN 'Rhode Island - RI'
            WHEN 'SC' THEN 'South Carolina - SC'
            WHEN 'SD' THEN 'South Dakota - SD'
            WHEN 'TN' THEN 'Tennessee - TN'
            WHEN 'TX' THEN 'Texas - TX'
            WHEN 'UT' THEN 'Utah - UT'
            WHEN 'VT' THEN 'Vermont - VT'
            WHEN 'VA' THEN 'Virginia - VA'
            WHEN 'VI' THEN 'US Virgin Islands - VI'
            WHEN 'WA' THEN 'Washington - WA'
            WHEN 'WV' THEN 'West Virginia - WV'
            WHEN 'WI' THEN 'Wisconsin - WI'
            WHEN 'WY' THEN 'Wyoming - WY'
        ELSE
            name
        END
        WHERE context = 'State Code';
    SQL
  end

  def down
    execute <<-SQL
    UPDATE tags set context = 'State Code', name = right(name, 2) where context = 'State';
    SQL
  end
end
