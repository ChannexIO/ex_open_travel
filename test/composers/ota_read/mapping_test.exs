defmodule ExOpenTravel.Composers.OtaRead.ResponseTest do
  use ExUnit.Case
  doctest ExOpenTravel
  @moduletag :ex_open_travel_response_ota_read
  import SweetXml
  alias ExOpenTravel.Response.Converter
  alias ExOpenTravel.Composers.OtaRead.Mapping

  @raw_message ~s|<OTA_ResRetrieveRS xmlns="http://www.opentravel.org/OTA/2003/05" Version="1.0" TimeStamp="2005-08-01T09:32:47+08:00" EchoToken="echo-abc123">
    <Success/>
    <ReservationsList>
        <HotelReservation CreateDateTime="2007-12-09T08:51:45.000+0000" ResStatus="Book">
            <POS>
                <Source>
                    <RequestorID Type="22" ID="SITEMINDER"/>
                    <BookingChannel Primary="true" Type="7">
                        <CompanyName Code="EXP">Expedia</CompanyName>
                    </BookingChannel>
                </Source>
                <Source>
                    <BookingChannel Primary="false" Type="7">
                        <CompanyName Code="EXPA">Expedia Affilate Account</CompanyName>
                    </BookingChannel>
                </Source>
            </POS>
            <UniqueID Type="14" ID="EXP-001"/>
            <UniqueID Type="16" ID="1243132" ID_Context="MESSAGE_UNIQUE_ID"/>
            <RoomStays>
                <RoomStay MarketCode="Corporate" PromotionCode="STAYANDSAVE" SourceOfBusiness="Radio">
                    <RoomTypes>
                        <RoomType RoomType="Double Room" RoomTypeCode="DR" NonSmoking="true" Configuration="2 Beds and 1 cot">
                            <RoomDescription>
                                <Text>Double room</Text>
                            </RoomDescription>
                            <AdditionalDetails>
                                <AdditionalDetail Type="4" Code="PIA">
                                    <DetailDescription>
                                        <Text>Room paid in advance with credit card</Text>
                                    </DetailDescription>
                                </AdditionalDetail>
                                <AdditionalDetail Type="7">
                                    <DetailDescription>
                                        <Text>Cancellation deadline 10/10/2012</Text>
                                    </DetailDescription>
                                </AdditionalDetail>
                            <AdditionalDetail Type="5" Code="ECB">
                                <DetailDescription>
                                    <Text>Continental breakfast included</Text>
                                </DetailDescription>
                            </AdditionalDetail>
                          </AdditionalDetails>
                        </RoomType>
                    </RoomTypes>
                    <RatePlans>
                        <RatePlan RatePlanCode="RAC1" EffectiveDate="2013-03-12" ExpireDate="2013-03-14" RatePlanName="RACK Rate1">
                            <RatePlanDescription>
                                <Text>Long Stay Discount</Text>
                            </RatePlanDescription>
                            <AdditionalDetails>
                                <AdditionalDetail Type="15" Code="EB1">
                                    <DetailDescription>
                                        <Text>Stay n Save promotion grants 10% discount</Text>
                                    </DetailDescription>
                                </AdditionalDetail>
                                <AdditionalDetail Type="43">
                                    <DetailDescription>
                                        <Text>Continental breakfast included</Text>
                                    </DetailDescription>
                                </AdditionalDetail>
                                <AdditionalDetail Type="5" Code="ECB">
                                    <DetailDescription>
                                        <Text>Expedia Collect</Text>
                                    </DetailDescription>
                                </AdditionalDetail>
                            </AdditionalDetails>
                        </RatePlan>
                        <RatePlan RatePlanCode="RAC2" EffectiveDate="2013-03-14" ExpireDate="2013-03-15" RatePlanName="RACK Rate2">
                            <RatePlanDescription>
                                <Text>Discounted Daily Rate</Text>
                            </RatePlanDescription>
                            <AdditionalDetails>
                                <AdditionalDetail Type="15" Code="EB1">
                                    <DetailDescription>
                                        <Text>Single Night Discount Promo</Text>
                                    </DetailDescription>
                                </AdditionalDetail>
                                <AdditionalDetail Type="43">
                                    <DetailDescription>
                                        <Text>Continental breakfast included</Text>
                                    </DetailDescription>
                                </AdditionalDetail>
                                <AdditionalDetail Type="5" Code="ECB">
                                    <DetailDescription>
                                        <Text>Expedia Collect</Text>
                                    </DetailDescription>
                                </AdditionalDetail>
                            </AdditionalDetails>
                        </RatePlan>
                    </RatePlans>
                    <RoomRates>
                        <RoomRate RoomTypeCode="DR" RatePlanCode="RAC1" NumberOfUnits="1">
                            <Rates>
                                <Rate UnitMultiplier="2" RateTimeUnit="Day" EffectiveDate="2013-03-12" ExpireDate="2013-03-14">
                                    <Base AmountBeforeTax="200.00" AmountAfterTax="220.00" CurrencyCode="USD">
                                        <Taxes Amount="20.00">
                                            <Tax Code="19" Percent="10" Amount="20.00">
                                                <TaxDescription>
                                                    <Text>GST 10 percent</Text>
                                                </TaxDescription>
                                            </Tax>
                                        </Taxes>
                                    </Base>
                                    <Total AmountBeforeTax="202.50" AmountAfterTax="222.75" CurrencyCode="USD">
                                        <Taxes Amount="20.25">
                                            <Tax Code="19" Percent="10" Amount="20.25">
                                                <TaxDescription>
                                                    <Text>GST 10 percent</Text>
                                                </TaxDescription>
                                            </Tax>
                                        </Taxes>
                                    </Total>
                                </Rate>
                            </Rates>
                            <ServiceRPHs>
                                <ServiceRPH RPH="1"/>
                            </ServiceRPHs>
                        </RoomRate>
                        <RoomRate RoomTypeCode="DR" RatePlanCode="RAC2" NumberOfUnits="1">
                            <Rates>
                                <Rate UnitMultiplier="1" RateTimeUnit="Day" EffectiveDate="2013-03-14" ExpireDate="2013-03-15">
                                    <Base AmountBeforeTax="100.00" AmountAfterTax="110.00" CurrencyCode="USD">
                                        <Taxes Amount="10.00">
                                            <Tax Code="19" Percent="10" Amount="10.00">
                                                <TaxDescription>
                                                    <Text>GST 10 percent</Text>
                                                </TaxDescription>
                                            </Tax>
                                        </Taxes>
                                    </Base>
                                    <Total AmountBeforeTax="102.50" AmountAfterTax="112.75" CurrencyCode="USD">
                                        <Taxes Amount="10.25">
                                            <Tax Code="19" Percent="10" Amount="10.25">
                                                <TaxDescription>
                                                    <Text>GST 10 percent</Text>
                                                </TaxDescription>
                                            </Tax>
                                        </Taxes>
                                    </Total>
                                </Rate>
                            </Rates>
                            <ServiceRPHs>
                                <ServiceRPH RPH="2"/>
                            </ServiceRPHs>
                        </RoomRate>
                    </RoomRates>
                    <ServiceRPHs>
                        <ServiceRPH RPH="3"/>
                    </ServiceRPHs>
                    <GuestCounts>
                        <GuestCount AgeQualifyingCode="10" Count="1"/>
                        <GuestCount AgeQualifyingCode="8" Count="1"/>
                        <GuestCount AgeQualifyingCode="7" Count="1"/>
                    </GuestCounts>
                    <TimeSpan Start="2013-03-12" End="2013-03-15"/>
                    <Total AmountAfterTax="568.25" CurrencyCode="USD"/>
                    <BasicPropertyInfo HotelCode="10107"/>
                    <ResGuestRPHs>
                        <ResGuestRPH RPH="1"/>
                    </ResGuestRPHs>
                    <Comments>
                        <Comment>
                            <Text>non-smoking Room requested, king bed</Text>
                        </Comment>
                    </Comments>
                </RoomStay>
            </RoomStays>
            <Services>
                <Service ServiceInventoryCode="EXTRA_BED" Inclusive="true" ServiceRPH="1" Quantity="1" ID="12345" ID_Context="CHANNEL" Type="18">
                    <Price>
                        <Base AmountBeforeTax="2.50" AmountAfterTax="2.75" CurrencyCode="USD">
                            <Taxes Amount="0.25">
                                <Tax Code="19" Percent="10" Amount="0.25">
                                    <TaxDescription>
                                        <Text>GST 10 percent</Text>
                                    </TaxDescription>
                                </Tax>
                            </Taxes>
                        </Base>
                        <Total AmountBeforeTax="5.00" AmountAfterTax="5.50" CurrencyCode="USD">
                            <Taxes Amount="0.50">
                                <Tax Code="19" Percent="10" Amount="0.50">
                                    <TaxDescription>
                                        <Text>GST 10 percent</Text>
                                    </TaxDescription>
                                </Tax>
                            </Taxes>
                        </Total>
                        <RateDescription>
                            <Text>Extra person charge $2.50 (ex GST) per day for cot</Text>
                        </RateDescription>
                    </Price>
                    <ServiceDetails>
                        <TimeSpan End="2013-03-14" Start="2013-03-12"/>
                    </ServiceDetails>
                </Service>
                <Service ServiceInventoryCode="EXTRA_BED" Inclusive="true" ServiceRPH="2" Quantity="1" ID="12346" ID_Context="CHANNEL" Type="18">
                    <Price>
                        <Base AmountBeforeTax="2.50" AmountAfterTax="2.75" CurrencyCode="USD">
                            <Taxes Amount="0.25">
                                <Tax Code="19" Percent="10" Amount="0.25">
                                    <TaxDescription>
                                        <Text>GST 10 percent</Text>
                                    </TaxDescription>
                                </Tax>
                            </Taxes>
                        </Base>
                        <Total AmountBeforeTax="2.50" AmountAfterTax="2.75" CurrencyCode="USD">
                            <Taxes Amount="0.25">
                                <Tax Code="19" Percent="10" Amount="0.25">
                                    <TaxDescription>
                                        <Text>GST 10 percent</Text>
                                    </TaxDescription>
                                </Tax>
                            </Taxes>
                        </Total>
                        <RateDescription>
                            <Text>Extra person charge $2.50 (ex GST) per day for cot</Text>
                        </RateDescription>
                    </Price>
                    <ServiceDetails>
                        <TimeSpan End="2013-03-15" Start="2013-03-14"/>
                    </ServiceDetails>
                </Service>
                <Service ServiceInventoryCode="OTHER" Inclusive="true" ServiceRPH="3" Quantity="2" ID="12347" ID_Context="CHANNEL" Type="18">
                    <Price>
                        <Base AmountBeforeTax="4.55" AmountAfterTax="5.00" CurrencyCode="USD">
                            <Taxes Amount="0.45">
                                <Tax Code="19" Percent="10" Amount="0.45">
                                    <TaxDescription>
                                        <Text>GST 10 percent</Text>
                                    </TaxDescription>
                                </Tax>
                            </Taxes>
                        </Base>
                        <Total AmountBeforeTax="9.09" AmountAfterTax="10.00" CurrencyCode="USD">
                            <Taxes Amount="0.91">
                                <Tax Code="19" Percent="10" Amount="0.91">
                                    <TaxDescription>
                                        <Text>GST 10 percent</Text>
                                    </TaxDescription>
                                </Tax>
                            </Taxes>
                        </Total>
                        <RateDescription>
                            <Text>Extra bathrobe $5.00 (incl GST) per person</Text>
                        </RateDescription>
                    </Price>
                </Service>
                <Service ServiceInventoryCode="EXTRA" Inclusive="true" Quantity="1" ID="12348" ID_Context="CHANNEL" Type="18">
                    <Price>
                        <Base AmountBeforeTax="4.55" AmountAfterTax="5.00" CurrencyCode="USD">
                            <Taxes Amount="0.45">
                                <Tax Code="19" Percent="10" Amount="0.45">
                                    <TaxDescription>
                                        <Text>GST 10 percent</Text>
                                    </TaxDescription>
                                </Tax>
                            </Taxes>
                        </Base>
                        <Total AmountBeforeTax="13.65" AmountAfterTax="15.00" CurrencyCode="USD">
                            <Taxes Amount="1.35">
                                <Tax Code="19" Percent="10" Amount="1.35">
                                    <TaxDescription>
                                        <Text>GST 10 percent</Text>
                                    </TaxDescription>
                                </Tax>
                            </Taxes>
                        </Total>
                        <RateDescription>
                            <Text>Car Park - Undercover Parking (Clearance 2.2 meter or 7.2 feet) $5.00 (incl GST) per day</Text>
                        </RateDescription>
                    </Price>
                    <ServiceDetails>
                        <TimeSpan End="2013-03-15" Start="2013-03-12"/>
                    </ServiceDetails>
                </Service>
            </Services>
            <ResGuests>
                <ResGuest ResGuestRPH="1" ArrivalTime="10:30:00" Age="8" PrimaryIndicator="true">
                    <Profiles>
                        <ProfileInfo>
                            <UniqueID Type="16" ID="12345" ID_Context="CHANNEL"/>
                            <Profile ProfileType="1">
                                <Customer>
                                    <PersonName>
                                        <NamePrefix>Mr</NamePrefix>
                                        <GivenName>James</GivenName>
                                        <MiddleName>Herbert</MiddleName>
                                        <Surname>Bond</Surname>
                                    </PersonName>
                                    <Telephone PhoneNumber="555-1234"/>
                                    <Telephone PhoneNumber="555-4321" PhoneUseType="4"/>
                                    <Telephone PhoneNumber="0411444000" PhoneTechType="5"/>
                                    <Telephone PhoneNumber="213451515" PhoneTechType="3"/>
                                    <Email>james.bond@mi5.co.uk</Email>
                                    <Address>
                                        <AddressLine>Claretta House</AddressLine>
                                        <AddressLine>Tower Bridge Close</AddressLine>
                                        <CityName>London</CityName>
                                        <PostalCode>EC1 2PG</PostalCode>
                                        <StateProv>Middlesex</StateProv>
                                        <CountryName>United Kingdom</CountryName>
                                        <CompanyName>MI6</CompanyName>
                                    </Address>
                                    <CustLoyalty MembershipID="1234567890" ProgramID="FrequentFlyer" ExpiryDate="2017-03-31"/>
                                </Customer>
                            </Profile>
                        </ProfileInfo>
                    </Profiles>
                    <Comments>
                        <Comment Name="ArrivalDetails">
                            <Text>Arriving by coach</Text>
                        </Comment>
                        <Comment Name="DepartureDetails">
                            <Text>Departure flight QF123</Text>
                        </Comment>
                    </Comments>
                </ResGuest>
            </ResGuests>
            <ResGlobalInfo>
                <Guarantee>
                    <GuaranteesAccepted>
                        <GuaranteeAccepted>
                            <PaymentCard CardCode="VI" CardType="1" CardNumber="4444444444444444" ExpireDate="1114">
                                <CardHolderName>John Smith</CardHolderName>
                            </PaymentCard>
                        </GuaranteeAccepted>
                    </GuaranteesAccepted>
                    <Comments>
                        <Comment Name="PaymentReferenceId">
                            <Text>123124151616</Text>
                        </Comment>
                    </Comments>
                    <GuaranteeDescription>
                        <Text>Payment accepted up front</Text>
                    </GuaranteeDescription>
                </Guarantee>
                <DepositPayments>
                    <GuaranteePayment>
                        <AmountPercent Amount="291.63" Percent="50" CurrencyCode="USD"/>
                        <Description>
                            <Text>50% Deposit</Text>
                        </Description>
                    </GuaranteePayment>
                </DepositPayments>
                <Fees>
                    <Fee TaxInclusive="true" Type="Inclusive" Code="27" Amount="5.00">
                        <Taxes Amount="0.45"/>
                        <Description Name="Commission">
                            <Text>Commission - $5 flat fee</Text>
                        </Description>
                    </Fee>
                </Fees>
                <Total AmountAfterTax="583.25" CurrencyCode="USD">
                    <Taxes Amount="53.02">
                        <Tax Code="19" Percent="10" Amount="53.52">
                            <TaxDescription>
                                <Text>GST 10 percent</Text>
                            </TaxDescription>
                        </Tax>
                    </Taxes>
                </Total>
                <HotelReservationIDs>
                    <HotelReservationID ResID_Type="14" ResID_Value="RES_3243525"/>
                </HotelReservationIDs>
                <Profiles>
                    <ProfileInfo>
                        <UniqueID Type="16" ID="12345" ID_Context="CHANNEL"/>
                        <Profile ProfileType="1">
                            <Customer>
                                <PersonName>
                                    <NamePrefix>Mr</NamePrefix>
                                    <GivenName>James</GivenName>
                                    <MiddleName>Herbert</MiddleName>
                                    <Surname>Bond</Surname>
                                </PersonName>
                                <Telephone PhoneNumber="555-1234"/>
                                <Telephone PhoneNumber="555-4321" PhoneUseType="4"/>
                                <Telephone PhoneNumber="0411444000" PhoneTechType="5"/>
                                <Telephone PhoneNumber="213451515" PhoneTechType="3"/>
                                <Email>james.bond@mi5.co.uk</Email>
                                <Address>
                                    <AddressLine>Claretta House</AddressLine>
                                    <AddressLine>Tower Bridge Close</AddressLine>
                                    <CityName>London</CityName>
                                    <PostalCode>EC1 2PG</PostalCode>
                                    <StateProv>Middlesex</StateProv>
                                    <CountryName>United Kingdom</CountryName>
                                    <CompanyName>MI6</CompanyName>
                                </Address>
                                <CustLoyalty MembershipID="1234567890" ProgramID="FrequentFlyer" ExpiryDate="2017-03-31"/>
                            </Customer>
                        </Profile>
                    </ProfileInfo>
                    <ProfileInfo>
                        <UniqueID Type="16" ID="STA" ID_Context="CHANNEL"/>
                        <UniqueID Type="16" ID="12312414" ID_Context="IATA"/>
                        <Profile ProfileType="4">
                            <Customer>
                                <PersonName>
                                    <NamePrefix>Mis</NamePrefix>
                                    <Surname>Moneypenny</Surname>
                                </PersonName>
                                <Telephone PhoneNumber="555-1234"/>
                                <Address>
                                    <CompanyName>STA Travel</CompanyName>
                                </Address>
                            </Customer>
                        </Profile>
                    </ProfileInfo>
                </Profiles>
                <Comments>
                    <Comment>
                        <Text>will be arriving after 6 pm</Text>
                    </Comment>
                </Comments>
            </ResGlobalInfo>
        </HotelReservation>
    </ReservationsList>
</OTA_ResRetrieveRS>
|

  @message %{
    OTA_ResRetrieveRS: %{
      ReservationsList: [
        %{
          HotelReservation: [
            %{
              BasicPropertyInfo: nil,
              CreateDateTime: "2007-12-09T08:51:45.000+0000",
              LastModifyDateTime: "",
              POS: [
                %{
                  Source: %{
                    BookingChannel: %{
                      CompanyName: %{Code: "EXP", CompanyName: "Expedia"},
                      Primary: "true",
                      Type: "7"
                    },
                    RequestorID: %{ID: "SITEMINDER", Type: "22"}
                  }
                }
              ],
              ResGlobalInfo: %{
                Comments: [%{Comment: [%{Text: "will be arriving after 6 pm"}]}],
                DepositPayments: [
                  %{
                    GuaranteePayment: [
                      %{
                        AmountPercent: %{
                          Amount: "291.63",
                          CurrencyCode: "USD",
                          Percent: "50",
                          TaxInclusive: ""
                        },
                        Description: %{Text: "50% Deposit"}
                      }
                    ]
                  }
                ],
                Fees: [
                  %{
                    Fee: [
                      %{
                        Amount: "5.00",
                        Code: "27",
                        Description: %{Name: "Commission", Text: "Commission - $5 flat fee"},
                        TaxInclusive: "true",
                        Taxes: [%{Tax: nil}],
                        Type: "Inclusive"
                      }
                    ]
                  }
                ],
                Guarantee: %{
                  Comments: [%{Comment: [%{Name: "PaymentReferenceId", Text: "123124151616"}]}],
                  GuaranteeDescription: [%{Text: "Payment accepted up front"}],
                  GuaranteesAccepted: [
                    %{
                      GuaranteeAccepted: %{
                        PaymentCard: %{
                          CardCode: "VI",
                          CardHolderName: "John Smith",
                          CardNumber: "4444444444444444",
                          CardType: "1",
                          ExpireDate: "1114",
                          MaskedCardNumber: "",
                          ThreeDomainSecurity: nil
                        }
                      }
                    }
                  ]
                },
                HotelReservationIDs: [
                  %{HotelReservationID: %{ResID_Type: "14", ResID_Value: "RES_3243525"}}
                ],
                Memberships: [],
                Profiles: [
                  %{
                    ProfileInfo: %{
                      Profile: %{
                        Customer: %{
                          Address: %{
                            AddressLine: "Claretta HouseTower Bridge Close",
                            CityName: "London",
                            CompanyName: "MI6",
                            CountryName: "United Kingdom",
                            PostalCode: "EC1 2PG",
                            StateProv: "Middlesex"
                          },
                          CustLoyalty: [
                            %{
                              ExpiryDate: "2017-03-31",
                              MembershipID: "1234567890",
                              ProgramID: "FrequentFlyer"
                            }
                          ],
                          Email: "james.bond@mi5.co.uk",
                          PersonName: %{
                            GivenName: "James",
                            MiddleName: "Herbert",
                            NamePrefix: "Mr",
                            Surname: "Bond"
                          },
                          Telephone: [
                            %{PhoneNumber: "555-1234", PhoneTechType: "", PhoneUseType: ""},
                            %{PhoneNumber: "555-4321", PhoneTechType: "", PhoneUseType: "4"},
                            %{PhoneNumber: "0411444000", PhoneTechType: "5", PhoneUseType: ""},
                            %{PhoneNumber: "213451515", PhoneTechType: "3", PhoneUseType: ""}
                          ]
                        },
                        ProfileType: "1"
                      },
                      UniqueID: [%{ID: "12345", ID_Context: "CHANNEL", Type: "16"}]
                    }
                  }
                ],
                Total: %{
                  AmountAfterTax: "583.25",
                  AmountBeforeTax: "",
                  CurrencyCode: "USD",
                  Taxes: [
                    %{
                      Tax: %{
                        Amount: "53.52",
                        Code: "19",
                        Percentage: "",
                        TaxDescription: %{Text: "GST 10 percent"}
                      }
                    }
                  ]
                }
              },
              ResGuests: [
                %{
                  ResGuest: %{
                    Age: "8",
                    ArrivalTime: "10:30:00",
                    Comments: [
                      %{
                        Comment: [
                          %{Name: "ArrivalDetails", Text: "Arriving by coach"},
                          %{Name: "DepartureDetails", Text: "Departure flight QF123"}
                        ]
                      }
                    ],
                    PrimaryIndicator: "true",
                    Profiles: [
                      %{
                        ProfileInfo: %{
                          Profile: %{
                            Customer: %{
                              Address: %{
                                AddressLine: "Claretta HouseTower Bridge Close",
                                CityName: "London",
                                CompanyName: "MI6",
                                CountryName: "United Kingdom",
                                PostalCode: "EC1 2PG",
                                StateProv: "Middlesex"
                              },
                              CustLoyalty: [
                                %{
                                  ExpiryDate: "2017-03-31",
                                  MembershipID: "1234567890",
                                  ProgramID: "FrequentFlyer"
                                }
                              ],
                              Email: "james.bond@mi5.co.uk",
                              PersonName: %{
                                GivenName: "James",
                                MiddleName: "Herbert",
                                NamePrefix: "Mr",
                                Surname: "Bond"
                              },
                              Telephone: [
                                %{PhoneNumber: "555-1234", PhoneTechType: "", PhoneUseType: ""},
                                %{PhoneNumber: "555-4321", PhoneTechType: "", PhoneUseType: "4"},
                                %{
                                  PhoneNumber: "0411444000",
                                  PhoneTechType: "5",
                                  PhoneUseType: ""
                                },
                                %{PhoneNumber: "213451515", PhoneTechType: "3", PhoneUseType: ""}
                              ]
                            },
                            ProfileType: "1"
                          },
                          UniqueID: [%{ID: "12345", ID_Context: "CHANNEL", Type: "16"}]
                        }
                      }
                    ],
                    ResGuestRPH: "1"
                  }
                }
              ],
              ResStatus: "Book",
              RoomStayReservation: "",
              RoomStays: [
                %{
                  RoomStay: %{
                    BasicPropertyInfo: %{HotelCode: "10107"},
                    Comments: [%{Comment: [%{Text: "non-smoking Room requested, king bed"}]}],
                    GuestCounts: [%{GuestCount: %{AgeQualifyingCode: "10", Count: "1"}}],
                    MarketCode: "Corporate",
                    PromotionCode: "STAYANDSAVE",
                    RatePlans: [
                      %{
                        RatePlan: %{
                          AdditionalDetails: [
                            %{
                              AdditionalDetail: %{
                                DetailDescription: %{
                                  Text: "Stay n Save promotion grants 10% discount"
                                },
                                Type: "15"
                              }
                            }
                          ],
                          EffectiveDate: "2013-03-12",
                          ExpireDate: "2013-03-14",
                          RateDescription: nil,
                          RatePlanCode: "RAC1",
                          RatePlanName: "RACK Rate1"
                        }
                      }
                    ],
                    ResGuestRPHs: [%{ResGuestRPH: %{RPH: "1"}}],
                    RoomRates: [
                      %{
                        RoomRate: %{
                          NumberOfUnits: "1",
                          RatePlanCode: "RAC1",
                          Rates: [
                            %{
                              Rate: %{
                                Base: %{
                                  AmountAfterTax: "222.75",
                                  AmountBeforeTax: "202.50",
                                  CurrencyCode: "USD",
                                  Taxes: [
                                    %{
                                      Tax: %{
                                        Amount: "20.25",
                                        Code: "19",
                                        Percentage: "",
                                        TaxDescription: %{Text: "GST 10 percent"}
                                      }
                                    }
                                  ]
                                },
                                EffectiveDate: "2013-03-12",
                                ExpireDate: "2013-03-14",
                                RateTimeUnit: "Day",
                                Total: %{
                                  AmountAfterTax: "222.75",
                                  AmountBeforeTax: "202.50",
                                  CurrencyCode: "USD",
                                  Taxes: [
                                    %{
                                      Tax: %{
                                        Amount: "20.25",
                                        Code: "19",
                                        Percentage: "",
                                        TaxDescription: %{Text: "GST 10 percent"}
                                      }
                                    }
                                  ]
                                },
                                UnitMultiplier: "2"
                              }
                            }
                          ],
                          RoomTypeCode: "DR",
                          ServiceRPHs: [%{ServiceRPH: %{RPH: "1"}}]
                        }
                      }
                    ],
                    RoomTypes: [
                      %{
                        RoomType: %{
                          AdditionalDetails: [
                            %{
                              AdditionalDetail: %{
                                DetailDescription: %{
                                  Text: "Room paid in advance with credit card"
                                },
                                Type: "4"
                              }
                            }
                          ],
                          Configuration: "2 Beds and 1 cot",
                          NonSmoking: "true",
                          RoomDescription: %{Text: "Double room"},
                          RoomType: "Double Room",
                          RoomTypeCode: "DR"
                        }
                      }
                    ],
                    ServiceRPHs: [%{ServiceRPH: %{RPH: "3"}}],
                    SourceOfBusiness: "Radio",
                    TimeSpan: %{End: "2013-03-15", Start: "2013-03-12"},
                    Total: %{
                      AmountAfterTax: "568.25",
                      AmountBeforeTax: "",
                      CurrencyCode: "USD",
                      Taxes: []
                    }
                  }
                }
              ],
              Services: [
                %{
                  Service: %{
                    ID: "12345",
                    ID_Context: "CHANNEL",
                    Inclusive: "true",
                    Price: %{
                      RateDescription: nil,
                      Total: %{
                        AmountAfterTax: "5.50",
                        AmountBeforeTax: "5.00",
                        CurrencyCode: "USD",
                        Taxes: [
                          %{
                            Tax: %{
                              Amount: "0.50",
                              Code: "19",
                              Percentage: "",
                              TaxDescription: %{Text: "GST 10 percent"}
                            }
                          }
                        ]
                      }
                    },
                    Quantity: "1",
                    ServiceDetails: %{TimeSpan: %{End: "2013-03-14", Start: "2013-03-12"}},
                    ServiceInventoryCode: "EXTRA_BED",
                    ServiceRPH: "1",
                    Type: "18"
                  }
                }
              ],
              UniqueID: [
                %{ID: "EXP-001", ID_Context: "", Type: "14"},
                %{ID: "1243132", ID_Context: "MESSAGE_UNIQUE_ID", Type: "16"}
              ]
            }
          ]
        }
      ],
      EchoToken: "echo-abc123",
      TimeStamp: "2005-08-01T09:32:47+08:00",
      Version: "1.0"
    }
  }

  test "convert success" do
    mapping = %{
      action: Mapping.get_action_name(),
      success_mapping: Mapping.get_mapping_for_success(),
      warning_mapping: Mapping.get_mapping_for_warnings(),
      error_mapping: Mapping.get_mapping_for_errors(),
      payload_mapping: Mapping.get_mapping_for_payload()
    }

    assert {:ok, @message, %{}} == Converter.convert({:ok, @raw_message, %{}}, mapping)
  end

  test "convert fail" do
    mapping = %{
      action: Mapping.get_action_name(),
      success_mapping: Mapping.get_mapping_for_success(),
      warning_mapping: Mapping.get_mapping_for_warnings(),
      error_mapping: Mapping.get_mapping_for_errors(),
      payload_mapping: Mapping.get_mapping_for_payload()
    }
    assert {:error,
            %ExOpenTravel.Error{
              reason:
                {:catch_error,
                 {:fatal,
                  {:expected_element_start_tag, {:file, :file_name_unknown}, {:line, 1},
                   {:col, 2}}}}
            },
            %{
              errors: [
                "Catch error: {:fatal, {:expected_element_start_tag, {:file, :file_name_unknown}, {:line, 1}, {:col, 2}}}}"
              ],
              success: false
            }} ==
             Converter.convert({:ok, "abrakadabra", %{}}, mapping)
  end
end
